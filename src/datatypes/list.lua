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

    list.clear = function(deep)
        if deep == nil then
            deep = true
        end

        if deep then
            local current = list.front
            local next = current.next

            while current do
                next = current.next

                current.next = nil
                current.previous = nil
                
                current = next
            end    
        end

        list.front = nil
        list.back = nil
        list.size = 0   
    end

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
        
        local value = list.back.value

        list.size = list.size - 1

        if list.back then
            if list.back.previous then
                list.back.previous.next = nil
                list.back = list.back.previous
            else
                list.back = nil
            end
        end
        
        return value
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

    
    list.popFront = function()
        if list.size == 0 then return end
        
        local value = list.front.value

        list.size = list.size - 1

        if list.front then
            if list.front.next then
                list.front.next.previous = nil
                list.front = list.front.next
            else
                list.front = nil
            end
        end
        
        return value
    end

    list.concat = function(other, clean)
        if other.__index ~= this.List then return end
        if clean == nil then
            clean = true
        end

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

    list.replaceAll = function(replaceWith, predicate)
        if not predicate then
            predicate = function(value)
                return true
            end
        end
        if type(predicate) ~= "function" then
            predicate = function(value)
                return value == predicate
            end
        end
        
        for _, current in pairs(list) do
            if predicate(current.value) then
                current.value = replaceWith
            end
        end
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

    list.remove = function(index)
        if index == 1 then
            return list.popFront()
        elseif index == list.size and index > 1 then
            return list.popBack()
        end

        local node = list.getNode(index)
        if node == nil then return end

        if node.previous then
            node.previous.next = node.next
        end
        if node.next then
            node.next.previous = node.previous
        end

        return node.value
    end

    list.splice = function(other, index, clean)
        local node = list.getNode(index)
        if clean == nil then
            clean = true
        end

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

this.List.__concat = function(list1, list2)
    local newList = this.List.new()
    newList.concat(list1)
    newList.concat(list2)
    
    return newList
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

this.List.iter = function(list)
    local i = 0
    local current = list.front
    return function()
        i = i + 1
        if i <= list.size and current then
            local node = current
            current = current.next
            return i, node
        end
    end
end

this.List.__pairs = function(list)
    return this.List.iter(list), list, nil
end

this.List.__call = function(list, index, indexEnd)
    if indexEnd == nil then
        return list.get(index)
    end
    return list.getRange(index, indexEnd)
end

this.List.sort = function(list, predicate)
    if predicate == nil then
        predicate = function(a, b)
            return a < b
        end
    end

    local tableFromList = this.List.toTable(list) 
    table.sort(tableFromList, predicate)

    return this.List.new(tableFromList)
end

return this