-------------------------------------------- Index - require moduleName shortener - Basilio German
local moduleName = ...

local index = setmetatable({}, {
	__call = function(self, newPathString)
		self.addPath(newPathString)
		return self
	end,
})
-------------------------------------------- Constants
local DOT = "."
-------------------------------------------- Caches
local tableInsert = table.insert
local stringGmatch = string.gmatch
local loaders = package.loaders
-------------------------------------------- Vars
local originalRequire
local lastRequirePath

local paths
local initialized

local tableStringFunctions
local paramsMetatable

local wasFound
-------------------------------------------- Local functions
local function paramsInjector(moduleName)	
	for index = 2, #loaders do
		local loaderFunction = loaders[index](moduleName)

		if "function" == type(loaderFunction) then
			return function(moduleName) -- Hook function will send params as table, disguised as string. (As Corona SDK does)
				local params = moduleName
				if lastRequirePath then -- Module was loaded off a custom path, init with custom params
					params = setmetatable({
						name = moduleName,
						path = lastRequirePath,
					}, paramsMetatable)
			
					lastRequirePath = nil -- Loader function will load module, which might have more requires inside.
				end -- NOTE: Plugins can not be loaded with custom params, they need their own name, plugin.notifications turns out as plugin_notifications in OSX
				
				wasFound[moduleName] = true
				
				local loaded = loaderFunction(params)
				
				return loaded
			end
		end
	end
end

local function requireIntecept(moduleName)
	-- Check loaded first
	if package.loaded[moduleName] then
		return package.loaded[moduleName]
	end
	
	-- Use original function first (Priority to main project files)
	local result, value = pcall(originalRequire, moduleName)
	
	if result then 
		return value
	elseif wasFound[moduleName] then -- Module was found but something crashed.
		if value then
			package.loaded[moduleName] = nil -- Nil out userdata, since we could not get past loading.
			error(value, 2)
		end
	else -- Module was not loaded by originalRequire, try indexed paths
		if #paths > 0 then -- Check paths if any
			for pathIndex = 1, #paths do
				if string.find(moduleName, paths[pathIndex]) == 1 then -- Check if path was already included
					break 
				end
				
				-- Attempt path find, path.module
				local newModuleName = paths[pathIndex]..DOT..moduleName
				
				if package.loaded[newModuleName] then -- If package was already loaded, injector will not inject anything, return loaded.
					return package.loaded[newModuleName]
				end
				
				lastRequirePath = paths[pathIndex]..DOT -- lastRequirePath will be reset after injector loads
				local newResult, newValue = pcall(originalRequire, newModuleName)
				
				if newResult then
					return newValue
				else -- Try directory find, path.module.module
					if wasFound[newModuleName] then -- Module was found, but it crashed inside
						package.loaded[newModuleName] = nil -- Nil out userdata, since we could not get past loading. (loaded first sets a userdata before loading the module.)
						error(newValue, 2)
					else
						newModuleName = newModuleName..DOT..moduleName
						
						if package.loaded[newModuleName] then -- If package was already loaded, injector will not inject anything, return loaded.
							return package.loaded[newModuleName]
						end
						
						lastRequirePath = lastRequirePath..moduleName..DOT -- lastRequirePath will be reset after injector loads
						newResult, newValue = pcall(originalRequire, newModuleName)
						
						if newResult then
							return newValue
						else
							if wasFound[newModuleName] then -- Crashed inside
								package.loaded[newModuleName] = nil -- Nil out userdata, since we could not get past loading.
								error(newValue, 2)
							else
								lastRequirePath = nil
							end
						end
					end
				end
			end
		end
	end
	
	-- Module could not be loaded any way, throw error
	if not result and value then
		error(value, 2)
	end
end

local function initialize()
	if not initialized then
		initialized = true
		
		wasFound = {}
		
		originalRequire = require -- Keep reference to original require function
		require = requireIntecept -- We will intercept require with our own
		
		paths = {}
		tableInsert(loaders, 1, paramsInjector) -- Insert our loader as the first one
		
		paramsMetatable = { -- Params will mimic a string (As intended by Corona SDK)
			__index = function(self, key)
				return tableStringFunctions[key]
			end,
			__tostring = function(self)
				return self.name
			end,
			__concat = function(self, str)
				return self.name..str
			end,
			__metatable = {},
		}
		
		tableStringFunctions = {}
		for key, value in pairs(string) do -- Copy string functions to mimic them
			tableStringFunctions[key] = function(self, ...)
				return string[key](self.name, ...)
			end
		end
	end
end
-------------------------------------------- Module functions
function index.addPath(...)
	local newPaths = {...}
	
	for index = 1, #newPaths do
		if "string" == type(newPaths[index]) then
			paths[#paths + 1] = newPaths[index]
		end
	end
end
-------------------------------------------- Execution
initialize()

return index