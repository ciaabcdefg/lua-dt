package.path = "datatypes/?.lua;" .. package.path -- include if you want to use the data types
package.path = "utils/?.lua;" .. package.path  -- include if you want to use the utils lib

do
    local list = require("list")
    List = list.List
    ArrayList = list.ArrayList

    local dsu = require("dsu")
    DSU = dsu.DSU

    local queue = require("queue")
    Queue = queue.Queue

    local tree = require("tree")
    Tree = tree.Tree
end

local benchmark = require("benchmark")

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

local tree = Tree.new()
tree.insert(9)
tree.insert(7, 9)
    tree.insert(5, 7)
    tree.insert(1, 7)
tree.insert(3, 9)
    tree.insert(2, 3)
    tree.insert(4, 3)
    
Tree.dfs(tree, 2)