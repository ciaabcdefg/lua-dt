-- Queue (doubly linked list wrapper)

local this = {}
local List = require("list")

this.Queue = {}
this.Queue.__index = this.Queue

do 
    this.Queue.new = function()
        local queue = {}
        queue.list = List.List.new()
        setmetatable(queue, this.Queue)
    
        queue.empty = function()
            return queue.list.empty()
        end
    
        queue.size = function()
            return queue.list.size
        end
    
        queue.front = function()
            return queue.list.front.value
        end
    
        queue.push = function(value)
            queue.list.pushBack(value)
        end
    
        queue.pop = function()
            return queue.list.popFront()
        end
        
        queue.clear = function()
            queue.list.clear(true)
        end
    
        return queue
    end
    
    this.Queue.__tostring = function(queue)
        return tostring(queue.list)
    end
    
    this.Queue.__len = function(queue)
        return #queue.list
    end
end

return this
