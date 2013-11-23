local LevelGenerator = {}
LevelGenerator.__index = LevelGenerator

setmetatable(LevelGenerator, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

function LevelGenerator.new()
    local self = setmetatable({}, LevelGenerator)
    self.lines = 30
    self.lineWidth = 30
    self.spawns = 2
    self.matchExpr = '[XOS]+'
    self.spawnChar = 'S'
    return self
end

function LevelGenerator:parseLevel(filename)
    valid = self:validateLevel(filename)
    if not valid then return nil end

    level = {}
    for line in io.lines(filename) do
        table.insert(level, line)
    end

    return level
end

function LevelGenerator:validateLevel(filename)
    lineCount = 0
    spawnPoints = 0
    for line in io.lines(filename) do 
        lineCount = lineCount + 1
        if lineCount > self.lines then
            break
        end
        if #line ~= self.lineWidth then 
            print("line " .. lineCount .. " is not 30 characters wide")
            return false
        end
        if #string.match(line, self.matchExpr) ~= #line then
            print("line " .. lineCount .. " contains illegal characters")
            return false
        end
        if string.find(line, self.spawnChar) then
            spawnPoints = spawnPoints + #string.match(line, '[S]+')
        end
    end
    if lineCount ~= self.lines then 
        print("got " .. lineCount .. " lines, expected " .. self.lines)
        return false
    end
    if spawnPoints ~= self.spawns then
        print("got " .. spawnPoints .. " spawns, expected " .. self.spawns)
        return false
    end
    return true
end

return LevelGenerator
