-------------------------------------------- folder1.another.something
local params = ...
local requirePath = params.path or ""
local folderPath = requirePath:gsub("%.", "/")

local something2 = require("test.folder2.something")

local something1 = {}
-------------------------------------------- Module functions
function something1.check()
	local image = display.newImage(folderPath.."folder1/another/example.png")
	image.x = display.contentCenterX
	image.y = display.contentCenterY + 256
	image:setFillColor(1, 0, 0)
end

return something1