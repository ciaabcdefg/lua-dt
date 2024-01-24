local list = require("src.datatypes.list")
local myList1 = list.List.new({5, 4, 2, 1, 10, 2})

print(table.unpack(myList1.getNodeRange(2, 6)))