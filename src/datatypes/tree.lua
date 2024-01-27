local this = {}
local Stack = require("stack").Stack
local Queue = require("queue").Queue

this.Tree = {}
this.Tree.__index = this.Tree
local Tree = this.Tree

this.Node = {}
this.Node.__index = this.Node
local Node = this.Node

do
    Node.new = function(value)
        local node = {}

        node.parent = nil
        node.value = value
        node.children = {}
        setmetatable(node, Node)

        return node
    end

    Node.__tostring = function(node)
        return "Node: value = " .. (tostring(node.value) or "")
    end
end

-- Global Methods
do
    this.getPredicate = function(predicate)
        if predicate == nil then return nil end

        if type(predicate) ~= "function" then
            return function(node)
                return node.value == predicate
            end
        end

        return predicate
    end
end

-- Generic Tree
do
    Tree.new = function()
        local tree = {}
        
        tree.root = nil
        setmetatable(tree, Tree)

        tree.insert = function(value, parent)
            if tree.root == nil and not parent then
                tree.root = Node.new(value)
                return
            end
            if not parent then return end

            local parentNode = tree.find(parent)
            if parentNode == nil then return end
            
            local node = Node.new(value)
            node.parent = parentNode

            table.insert(parentNode.children, node)
        end

        tree.find = function(predicate)
            predicate = this.getPredicate(predicate)
            if predicate == nil then return nil end

            local stack = Stack.new()
            stack.push(tree.root)

            while not stack.empty() do
                local top = stack.pop()
                if not top then goto continue end

                if predicate(top) then
                    return top
                end

                for _, child in pairs(top.children) do
                    stack.push(child)
                end
                ::continue::
            end

            return nil
        end

        tree.show = function(indentSpace)
            Tree.show(tree, indentSpace)
        end

        tree.showBFS = function()
            Tree.showBFS(tree)
        end

        tree.showDFS = function()
            Tree.showDFS(tree)
        end

        return tree
    end

    Tree.showBFS = function(tree)
        local queue = Queue.new()
        local levels = {}

        queue.push(tree.root)
        levels[tree.root] = 0
        io.write("0: ")

        local curLevel = 0
        while not queue.empty() do
            local front = queue.pop()
            if front == nil then goto continue end

            if levels[front] > curLevel then
                io.write('\n', levels[front] .. ": ")
                curLevel = levels[front]
            end
            io.write(front.value .. ' ')
            

            for _, child in pairs(front.children) do
                levels[child] = levels[front] + 1
                queue.push(child)        
            end
            ::continue::
        end
    end        

    Tree.showDFS = function(tree)
        print(tree)
    end

    Tree.show = function(tree, indentSpace)
        local stack = Stack.new()
        local indent = {}
        if indentSpace == nil then
            indentSpace = 4
        end

        stack.push(tree.root)
        indent[tree.root] = 0

        while not stack.empty() do
            local top = stack.pop()
            if not top then goto continue end
            
            for i = 1, indent[top] * indentSpace do
                io.write(' ')
            end
            
            io.write(top.value)
            io.write('\n')

            local inverseStack = Stack.new()
            for _, child in pairs(top.children) do
                indent[child] = indent[top] + 1
                inverseStack.push(child)
            end
            
            while not inverseStack.empty() do
                stack.push(inverseStack.pop())
            end

            ::continue::
        end
    end

    Tree.__tostring = function(tree)
        local stack = Stack.new()
        local str = ""
        stack.push(tree.root)
        
        while not stack.empty() do
            local top = stack.pop()
            if not top then goto continue end
            
            str = str .. top.value .. ", "

            for _, child in pairs(top.children) do
                stack.push(child)
            end
            ::continue::
        end

        str = string.sub(str, 1, str.len(str) - 2)
        return str
    end
end

return this