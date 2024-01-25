local list = require("src.datatypes.list")
local dsu = require("src.datatypes.dsu")
local stack = require("src.datatypes.stack")
local queue = require("src.datatypes.queue")


local q = queue.Queue.new(6)
q.push(5)
q.push(2)
q.push(10)

print(q)
q.clear()

print(q)