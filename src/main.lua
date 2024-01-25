local list = require("src.datatypes.list")
local dsu = require("src.datatypes.dsu")
local stack = require("src.datatypes.stack")

local array = list.ArrayList.new({1, 2, 3, 4, 5, 3, 3, 3})
local l = list.List.new({1, 2, 3, 4, 5})

print(array)

print(array.findAll(3))

array.clear()

print(array)