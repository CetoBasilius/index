-------------------------------------------- folder1.something
local params = ...

local something2 = require("test.folder2.something")

local something1 = {}
-------------------------------------------- Module functions
function something1.check()
	something2.check()
end

return something1