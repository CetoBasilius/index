-------------------------------------------- folder1.something
local params = ...

local something2 = require("test.folder2.something") -- This uses the namespace "test" so that it knows it is referencing a file inside this shortened path.

local something1 = {}
-------------------------------------------- Module functions
function something1.check()
	something2.check()
end

return something1