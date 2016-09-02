-------------------------------------------- folder2.something
local params = ...
local requirePath = params.path or ""
local folderPath = requirePath:gsub("%.", "/")

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