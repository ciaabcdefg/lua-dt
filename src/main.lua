local list = require("src.datatypes.list")
local myList1 = list.List.new({1, 2, "Replace This!", 4, 5})

print(myList1)

myList1.replaceAll(0, function(value)
    return type(value) == "string"
end)

myList1.replaceAll(999)

print(myList1)