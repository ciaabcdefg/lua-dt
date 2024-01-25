-- Stack

local this = {}

this.Stack = {}
this.Stack.__index = this.Stack

this.Stack.new = function()
    local stack = {}
    stack.table = {}
    stack.top = nil
    stack.size = 0
    setmetatable(stack, this.Stack)

    stack.push = function(value)
        stack.size = stack.size + 1
        stack.table[stack.size] = value
        stack.top = value
    end

    stack.pop = function()
        if stack.empty() then return nil end

        local top = stack.top

        stack.table[stack.size] = nil
        stack.size = stack.size - 1
        stack.top = stack.table[stack.size]

        return top
    end

    stack.clear = function()
        stack.table = {}
        stack.top = nil
        stack.size = 0
    end

    stack.empty = function()
        return stack.size < 1
    end

    return stack
end

this.Stack.__len = function(stack)
    return stack.size
end

this.Stack.__tostring = function(stack)
    local str = "["
    local terminator = ", "

    for i = stack.size, 1, -1 do
        if i == 1 then
            terminator = ""
        end

        str = str .. tostring(stack.table[i]) .. terminator
    end
    str = str .. "]"

    return str
end

return this