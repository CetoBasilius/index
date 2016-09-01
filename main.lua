-------------------------------------------- Main
require("index")("path.to.libs") -- Add "path.to.libs" folder to index

local library1 = require("library1") -- Load "path.to.libs.library1" just by requiring "library1"
local library2 = require("library2")

library1.check()
library2.check()

local testLib1Again = require("library1")
testLib1Again.check()