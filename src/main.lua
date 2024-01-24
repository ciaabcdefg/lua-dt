local list = require("src.datatypes.list")
local myList = list.List.new({"Mark", "John", "James", "David"})

print(myList.getNode(2))
print(myList.getNode(-2))
print(myList.getNode(-4))