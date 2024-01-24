local list = require("src.datatypes.list")

local l1 = list.List.new({1, 2, 5, 4})
local l2 = list.List.new({9, 6, 3})

print(l1)
print(l2)

l1.splice(l2, 0)

l1.set(-1, 1000)
print(l1)

local sublist = list.List.new(l1.getRange(2, 5))
print(sublist)