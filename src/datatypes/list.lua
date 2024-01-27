local this = {}

this.List = {}
-- this.List.__index = this.List

this.Node = {}
this.Node.__index = this.Node

this.ArrayList = {}

-- Global Methods
do
    this.getPredicate = function(predicate)
        if predicate == nil then return nil end

        if type(predicate) ~= "function" then
            return function(value)
                return value == predicate
            end
        end

        return predicate
    end

    this.indexNormalized = function(size, index, boundsCheck)
        if boundsCheck == nil then
            boundsCheck = true
        end

        if (index > size or index < -size) and boundsCheck then return nil end

        if index < 0 then
            index = size + (index + 1)
        end

        if index > size then
            return size
        end
        return index
    end

    this.range = function(list, lower, upperInclusive, step)
        if step == nil then
            if lower > upperInclusive then
                step = -1
            else
                step = 1
            end
        end

        for i = lower, upperInclusive, step do
            list.pushBack(i)
        end
        return list
    end
end

-- Node
do
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
end

-- Doubly Linked List
do 
    local function find(list, predicate)
        predicate = this.getPredicate(predicate)
        if predicate == nil then return end

        for i, current in pairs(list) do
            if predicate(current.value) then
                return i, current
            end
        end
    
        return nil, nil
    end
    
    local function findAll(list, predicate, getValue)
        predicate = this.getPredicate(predicate)
        if predicate == nil then return nil end

        if getValue == nil then
            getValue = true
        end

        local collector = this.List.new()

        for _, node in pairs(list) do
            if predicate(node.value) then
                if getValue then
                    collector.pushBack(node.value)
                else
                    collector.pushBack(node)
                end                
            end
        end

        return collector
    end        

    local function get(list, index)
        if (index > list.size or index < -list.size) then return nil, nil end
        if index < 0 then
            index = list.size + (index + 1)
        end

        local iter
        if index > list.size * 0.5 then
            iter = this.List.iter(list, true)
        else
            iter = this.List.iter(list, false)
        end

        for i, current in iter do
            if i == index then
                return current.value, current
            end
        end
    end
    
    this.List.new = function(fromTable)
        local list = {}
        list.front = nil
        list.back = nil
        list.size = 0
        setmetatable(list, this.List)
    
        list.empty = function()
            return list.size == 0
        end

        list.clear = function(deep)
            this.List.clear(list, deep)
        end
    
        list.pushBack = function(value)
            this.List.pushBack(list, value)
        end
    
        list.popBack = function()
            if list.empty() then return end
            
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
            if value == nil then return end
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
            return this.List.popFront(list)
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
    
        list.find = function(predicate)
            local index = find(list, predicate)
            return index
        end
    
        list.findAll = function(predicate)
            return findAll(list, predicate, true)
        end

        list.findNode = function(predicate)
            local _, node = find(list, predicate)
            return node
        end
    
        list.findNodeAll = function(predicate)
            return findAll(list, predicate, false)
        end

        list.get = function(index)
            local value = get(list, index)
            return value
        end
    
        list.getNode = function(index)
            local _, node = get(list, index)
            return node
        end

        list.swap = function(index1, index2)
            local node1 = list.getNode(index1)
            local node2 = list.getNode(index2)
            if node1 == nil or node2 == nil then return end

            local temp = node1.value
            node1.value = node2.value
            node2.value = temp
        end
    
        list.getRange = function(indexStart, indexEnd)
            local newList = this.List.new()
    
            local startNode = list.getNode(indexStart)
            local endNode = list.getNode(indexEnd)
            
            if startNode == nil then 
                return nil
            end
            
            if endNode == nil then
                indexEnd = list.size
                endNode = list.back
            end
    
            newList.front = startNode
            newList.endNode = endNode
            newList.size = indexEnd - indexStart + 1
    
            return newList
        end
    
        list.getNodeRange = function(indexStart, indexEnd)
            local nodes = {}
    
            for i, current in pairs(list) do
                if i > indexEnd then break end
                if i >= indexStart then
                    table.insert(nodes, current)
                end
            end
    
            return nodes
        end
    
        list.replaceAll = function(replaceWith, predicate)
            if not predicate then
                predicate = function(value)
                    return true
                end
            end
            predicate = this.getPredicate(predicate)
            if predicate == nil then return end

            for _, current in pairs(list) do
                if predicate(current.value) then
                    current.value = replaceWith
                end
            end
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
    
            list.size = list.size - 1
    
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

    this.List.range = function(lower, upperInclusive, step)
        return this.range(this.List.new(), lower, upperInclusive, step)
    end

    this.List.toTable = function(list)
        local t = {}
    
        for _, current in pairs(list) do
            table.insert(t, current.value)
            current = current.next
        end
    
        return t
    end

    this.List.pushBack = function(list, value)
        if value == nil then return end
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
    
    this.List.popFront = function(list)
        if list.empty() then return end
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

    this.List.clear = function(list, deep)
        if deep == nil then
            deep = true
        end

        if deep then
            local current = list.front
            local next = nil

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
        local str = "["
        local terminator = ", "
    
        for i, current in pairs(list) do
            if i >= list.size then
                terminator = ""
            end
    
            str = str .. (tostring(current.value) or "nil") .. terminator
        end
    
        str = str .. "]"
    
        return str
    end
    
    this.List.iter = function(list, reversed)
        local i = 0
        local current

        if reversed == nil then
            reversed = false
        end

        if reversed then
            current = list.back
        else
            current = list.front
        end
        
        return function()
            i = i + 1
            if i <= list.size and current then
                local node = current

                if reversed then
                    current = current.previous
                else
                    current = current.next
                end

                local index
                if reversed then
                    index = list.size - i + 1
                else
                    index = i
                end

                return index, node
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
    
    this.List.__index = function(list, index)
        if type(index) == "number" then
            return list.get(index)
        end
        return rawget(list, index)
    end

    this.List.__newindex = function(list, index, value)
        if type(index) == "number" then
            list.set(index, value)
            return
        end
        rawset(list, index, value)
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
end

-- Dynamic Array (ArrayList)
do 
    this.ArrayList.new = function(fromTable)
        local list = {}
        list.size = 0
        list.array = fromTable or {}
        if fromTable then
            list.size = #fromTable
        end

        setmetatable(list, this.ArrayList)
    
        list.pushBack = function(value)
            if value == nil then return end
            
            list.size = list.size + 1
            list.array[list.size] = value
        end

        list.popBack = function()
            if list.size < 1 then return nil end

            local value = list.array[list.size] 
            list.size = list.size - 1
            return value
        end

        list.get = function(index)
            index = this.indexNormalized(list.size, index, true)
            return list.array[index]
        end

        list.getRange = function(indexStart, indexEnd)
            if indexStart == nil then return nil end
            indexEnd = indexEnd or indexStart

            indexStart = this.indexNormalized(list.size, indexStart, false)
            indexEnd = this.indexNormalized(list.size, indexEnd, false)

            local values = this.ArrayList.new()
            for i = indexStart, indexEnd do
                values.pushBack(list(i))
            end

            return values
        end

        list.swap = function(index1, index2)
            local temp = list[index1]
            list[index1] = list[index2]
            list[index2] = temp
        end

        list.set = function(index, value)
            index = this.indexNormalized(list.size, index, true)
            if index == nil then return end

            list.array[index] = value
        end

        list.find = function(predicate)
            predicate = this.getPredicate(predicate)
            if predicate == nil then return nil end

            for i, element in pairs(list) do
                if predicate(element) then
                    return i
                end
            end
            return nil
        end

        list.findAll = function(predicate)
            predicate = this.getPredicate(predicate)
            if predicate == nil then return end

            local indexList = this.ArrayList.new()
            for i, element in pairs(list) do
                if predicate(element) then
                    indexList.pushBack(i)
                end
            end
            
            return indexList
        end

        list.remove = function(index)
            if list.size < 1 then return nil end
            if index == list.size then
                return list.popBack()
            end

            local value = list.array[index]
            table.remove(list.array, index)
            list.size = list.size - 1

            return value
        end

        list.clear = function()
            list.array = {}
            list.size = 0
        end

        return list
    end

    this.ArrayList.range = function(lower, upperInclusive, step)
        return this.range(this.ArrayList.new(), lower, upperInclusive, step)
    end
    
    this.ArrayList.__tostring = function(list)
        local str = "["
        local terminator = ", "

        for i, element in pairs(list) do
            if i == list.size then
                terminator = ""
            end
            str = str .. tostring(element) .. terminator
        end

        str = str .. "]"
        return str
    end

    this.ArrayList.__pairs = function(list)
        return this.ArrayList.iter(list), list, nil
    end

    this.ArrayList.__call = function(list, index, indexEnd)
        if indexEnd == nil then
            return list.get(index)
        end
        return list.getRange(index, indexEnd)
    end

    this.ArrayList.__index = function(list, index)
        if type(index) == "number" then
            return list.get(index)
        end
        return rawget(list, index)
    end

    this.ArrayList.__newindex = function(list, index, value)
        if type(index) == "number" then
            list.set(index, value)
            return
        end
        rawset(list, index, value)
    end

    this.ArrayList.indexedIter = function(list, i)
        return function()
            i = i + 1
            if i <= list.size then
                return i, list.array[i]
            end
        end
    end

    this.ArrayList.iter = function(list)
        local i = 0
        return this.ArrayList.indexedIter(list, i)
    end
end



return this