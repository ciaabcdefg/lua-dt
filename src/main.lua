local list = require("src.datatypes.list")
local myList = list.List.new({"One", 2, "Three", 4, "Five"})

myList.remove(1)
print(myList)

myList.remove(2)
print(myList)

myList.remove(3)
print(myList)