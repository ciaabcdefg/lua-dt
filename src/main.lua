package.path = "datatypes/?.lua;" .. package.path -- include if you want to use the data types
package.path = "utils/?.lua;" .. package.path  -- include if you want to use the utils lib

do
    local module = require("list")
    List = module.List
    ArrayList = module.ArrayList
end

do
    local module = require("dsu")
    DSU = module.DSU
end

do
    local module = require("queue")
    Queue = module.Queue
end

local benchmark = require("benchmark")
local dsu = DSU.new()
local q = Queue.new()

dsu.newSet(1)
dsu.newSet(2)

print(dsu)

local function testGet()
    local count = 10000
    local iters = 10000
    
    print("Generating ArrayList...")
    local arr = ArrayList.range(1, count)
    print("Generating List...")
    local list = List.range(1, count)
    
    print("Test Commenced\n")
    print("ArrayList.get(size * 0.5)")
    benchmark.timer(iters, function()
        arr.get(arr.size * 0.5)
    end)
    print()
    print("List.get(size * 0.5)")
    benchmark.timer(iters, function()
        list.get(arr.size * 0.5)
    end)
end

local function testLen()
    local count = 100000000
    local iters = 1
    
    print("Generating ArrayList...")
    local arr = ArrayList.range(1, count)
    print("Generating Table...")
    local t = {}
    for i = 1, count do
        table.insert(t, i)
    end

    print("Test Commenced\n")
    print("ArrayList.size")
    benchmark.timer(iters, function()
        local sz = arr.size
    end)
    print()
    print("#table")
    benchmark.timer(iters, function()
        local sz = #t
    end)
end