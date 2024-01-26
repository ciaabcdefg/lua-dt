-- Disjoint Set Union (Union-Find)

local this = {}
local Stack = require("datatypes.stack")

this.DSU = {}

this.DSU.new = function()
    local dsu = {}
    dsu.parents = {}
    dsu.ranks = {}
    dsu.sets = {}
    
    setmetatable(dsu, this.DSU)

    dsu.find = function(element)
        if dsu.parents[element] == nil then return nil end

        local root = element
        while root ~= dsu.parents[root] do
            root = dsu.parents[root]
        end

        while element ~= root do
            local tempNext = dsu.parents[element]
            dsu.parents[element] = root
            dsu.sets[root][element] = element

            element = tempNext
        end

        return root
    end

    dsu.newSet = function(set)
        if dsu.parents[set] ~= nil then return end

        dsu.parents[set] = set
        dsu.ranks[set] = 1

        dsu.sets[set] = {set}
    end

    dsu.union = function(element1, element2) 
        local root1 = dsu.find(element1)
        local root2 = dsu.find(element2)

        if not root1 or not root2 then return end

        if root1 == root2 then
            return
        end

        if dsu.ranks[root1] < dsu.ranks[root2] then
            dsu.ranks[root2] = dsu.ranks[root1] + dsu.ranks[root2]
            dsu.parents[root1] = root2
            dsu.sets[root2][root1] = root1
        else
            dsu.ranks[root1] = dsu.ranks[root1] + dsu.ranks[root2]
            dsu.parents[root2] = root1
            dsu.sets[root1][root2] = root2
        end
    end

    dsu.showPairs = function()
        local str = "{"

        for child, parent in pairs(dsu.parents) do
            str = str .. "(" .. tostring(child) .. ": " .. tostring(parent) .. "), "
        end
    
        str = str .. "}"
        print(str)
    end

    dsu.contains = function(set, element)
        local stack = Stack.Stack.new()

        stack.push(set)
        while not stack.empty() do
            local top = stack.pop()
            if top == element then
                return true
            end

            local setTable = dsu.sets[top]
            if not setTable then goto continue end

            for _, child in pairs(setTable) do
                if top == child then goto continue end
                stack.push(child)
                ::continue::
            end

            ::continue::
        end
        return false
    end

    return dsu
end

this.DSU.__len = function(dsu)
    return #dsu.parents
end

this.DSU.__tostring = function(dsu)
    local str = "{"

    for parent, childList in pairs(dsu.sets) do
        local childStr = "{"
        for _, child in pairs(childList) do
            childStr = childStr .. child .. ", "
        end
        childStr = childStr .. "}"
        str = str .. "(" .. tostring(parent) .. ": " .. childStr .. "), "
    end
    
    str = str .. "}"
    return str
end

return this