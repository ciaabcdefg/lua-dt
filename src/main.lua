local list = require("src.datatypes.list")
local myList1 = list.List.new({5, 5, 2})
local myList2 = list.List.new({9, 8, "End"})
local myList3 = list.List.new({"Front"})

myList1.concat(myList2)
print(myList1)
print(myList2)

myList3.concat(myList1, false)
print(myList3)
print(myList1)