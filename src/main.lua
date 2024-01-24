local list = require("src.datatypes.list")
local myList1 = list.List.new({1})

local val = myList1.popBack()
print(myList1)
print(val)