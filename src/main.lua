do
    local module = require("src.datatypes.list")
    List = module.List
    ArrayList = module.ArrayList
end
local benchmark = require("src.utils.benchmark")

local function testGet()
    local count = 10000
    local iters = 10000
    
    print("Generating ArrayList...")
    local arr = ArrayList.range(1, count)
    print("Generating List...")
    local list = List.range(1, count)
    
    print("Test Commenced")
    benchmark.timer(iters, function()
        arr.get(arr.size * 0.5)
    end)
    benchmark.timer(iters, function()
        list.get(arr.size * 0.5)
    end)
end

testGet()