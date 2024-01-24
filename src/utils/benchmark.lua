local this = {}

this.timer = function(iterations, functionToTest, ...)
    local startTime = os.clock()

    for _ = 1, iterations do
        functionToTest(...)
    end

    local elapsedTime = os.clock() - startTime
    print("Benchmark results: " .. iterations .. " iterations in " .. elapsedTime .. " s")
end

this.genTable = function(count, lower, upper)
    lower = lower or -10000
    upper = upper or 10000

    local t = {}
    
    for i = 1, count do
        t[i] = math.random(lower, upper)
    end
    return t
end

return this