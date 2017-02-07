-------------------------------------------- Main
require("index")("path.to.libs")("index") -- Add "path.to.libs" folder to index, add "index" namespace

local test = require("test") -- This will shorten "path.to.libs.test.test"
test.check() 

local testFirst = require("test.folder1.something") -- This will shorten "path.to.libs.test.folder1.something"
testFirst.check()

require("index.path.internal")


local testSecond = require("test.folder2.something") -- This will shorten "path.to.libs.test.folder2.something"
testSecond.checkOther()