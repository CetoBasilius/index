-------------------------------------------- Example library 2
local params = ...

local library = {}
-------------------------------------------- Module functions
function library.check()
	local name = params.name
	local path = params.path

	print("Library 2 is working")
	print(string.format([[Name "%s" Path "%s"]], name, path))
end

return library