-------------------------------------------- folder2.something
local params = ...
local requireName = params.name or "" -- This will return "path.to.libs.test.folder2.something" but we don't use it here.
local requirePath = params.path or "" -- This will return "path.to.libs.test."
local folderPath = requirePath:gsub("%.", "/") -- We convert dots to path to load image

local something = {}
-------------------------------------------- Module functions
function something.check()
	print("I am folder2.something!")
	
	local image = display.newImage(folderPath.."folder2/example.png")
	image.x = display.contentCenterX
	image.y = display.contentCenterY
end

function something.checkOther()
	local anotherSomething = require("test.folder1.another.something")
	anotherSomething.check()
end

return something