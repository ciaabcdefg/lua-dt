-- (Doubly) Linked List

local this = {}

this.List = {}
this.List.__index = this.List

this.Node = {}
this.Node.__index = this.Node

this.Node.new = function(value)
    local node = {}
    node.value = value
    node.next = nil
    node.previous = nil
    setmetatable(node, this.Node)
    
    return node
end

this.Node.__tostring = function(node)
    return "Node: value = " .. (tostring(node.value) or "")
end

local function find(list, value)
    local current = list.front

    for i = 1, list.size do
        if not current then break end

        if current.value == value then
            return i, current
        end
        
        current = current.next
    end

    return -1, nil
end

local function get(list, index)
    if (index > list.size or index < -list.size) then return nil, nil end
    if index < 0 then
        index = list.size + (index + 1)
    end

    local current = list.front

    for i = 1, index do
        if not current then return nil, nil end

        if i == index then
            return current.value, current
        end

        current = current.next;
    end
end

this.List.toTable = function(list)
    local t = {}
    local current = list.front

    for _ = 1, list.size do
        if not current then break end
        table.insert(t, current.value)
        current = current.next
    end
    
    return t
end

this.List.new = function(fromTable)
    local list = {}
    list.front = nil
    list.back = nil
    list.size = 0
    setmetatable(list, this.List)

    list.pushBack = function(value)
        local node = this.Node.new(value)

        if not list.front then
            list.front = node
        end
        
        if list.back then
            list.back.next = node
        end

        node.previous = list.back
        list.size = list.size + 1
        list.back = node
    end

    list.popBack = function()
        if list.size == 0 then return end
        
        list.size = list.size - 1
        list.back.previous.next = nil
        
        return list.back.value
    end
    
    list.clear = function(deep)
        deep = deep or true
        list.front = nil
        list.back = nil
        list.size = 0
    end

    list.pushFront = function(value)
        local node = this.Node.new(value)

        if not list.back then
            list.back = node
        end
        
        if list.front then
            list.front.previous = node
        end

        node.next = list.front
        list.size = list.size + 1
        list.front = node
    end

    list.concat = function(other, clean)
        if other.__index ~= this.List then return end
        clean = clean or true

        list.size = list.size + other.size
        
        if list.back then
            list.back.next = other.front
        else
            list.front = other.front
        end
        list.back = other.back

        if other.front then
            other.front.previous = list.back
        end

        if clean then
            other.clear(false)
        end        
    end

    list.find = function(value)
        local index = find(list, value)
        return index
    end

    list.findNode = function(value)
        local _, node = find(list, value)
        return node
    end

    list.get = function(index)
        local value = get(list, index)
        return value
    end

    list.getNode = function(index)
        local _, node = get(list, index)
        return node
    end

    list.getRange = function(indexStart, indexEnd)
        local values = {}
        local current = list.front
        
        for i = 1, list.size do
            if i > indexEnd then break end
            if not current then break end

            if i >= indexStart then
                table.insert(values, current.value)
            end
            current = current.next
        end

        return values
    end

    list.getNodeRange = function(indexStart, indexEnd)
        local nodes = {}
        local current = list.front
        
        for i = 1, list.size do
            if i > indexEnd then break end
            if not current then break end

            if i >= indexStart then
                table.insert(nodes, current)
            end
            current = current.next
        end

        return nodes
    end

    list.set = function(index, value)
        local node = list.getNode(index)
        if not node then return end

        node.value = value
    end

    list.splice = function(other, index, clean)
        local node = list.getNode(index)
        clean = clean or true

        if node == nil then
            if other.back then
                other.back.next = list.front
            end
            list.front = other.front
        else
            local tempNext = node.next
            node.next = other.front
            other.back.next = tempNext
        end
        list.size = list.size + other.size
        
        if clean then
            other.clear(false)
        end
    end

    fromTable = fromTable or {}
    for _, element in pairs(fromTable) do
        list.pushBack(element)
    end

    return list
end

this.List.__len = function(list)
    return list.size
end

this.List.__tostring = function(list)
    local current = list.front
    local str = "["

    for _ = 1, list.size do
        if not current then break end

        local terminator = ", "
        if not current.next then
            terminator = ""
        end

        str = str .. (tostring(current.value) or "nil") .. terminator
        current = current.next;
    end

    str = str .. "]"

    return str
end

return this