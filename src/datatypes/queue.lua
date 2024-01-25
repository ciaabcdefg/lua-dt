-- Queue (doubly linked list wrapper)

local this = {}
local List = require("src.datatypes.list")

this.Queue = {}
this.Queue.__index = this.Queue

do 
    this.Queue.new = function()
        local queue = {}
        setmetatable(queue, this.Queue)
        
        queue.front = nil
        queue.back = nil
        queue.size = 0

        queue.push = function(value)
            List.List.pushBack(queue, value)
        end

        queue.pop = function()
            return List.List.popFront(queue)
        end

        queue.empty = function()
            return queue.size == 0
        end

        queue.clear = function()
            List.List.clear(queue) 
        end

        return queue
    end

    this.Queue.__tostring = List.List.__tostring
    this.Queue.__pairs = List.List.__pairs
    this.Queue.__len = List.List.__len
end

return this
