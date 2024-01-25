local list = require("src.datatypes.list")
local dsu = require("src.datatypes.dsu")
local stack = require("src.datatypes.stack")
local queue = require("src.datatypes.queue")

local arr = list.ArrayList.range(0.5, 0.1, -0.1)
print(arr)