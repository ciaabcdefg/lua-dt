local list = require("src.datatypes.list")
local myList1 = list.List.new({5, 4, 2, 1})

local sorted = list.List.sort(myList1)

print(sorted)