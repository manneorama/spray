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
end

function LevelGenerator:validateLevel(filename)
    lineCount = 0
    spawnPoints = 0
    for line in io.open(filename):lines() do 
        lineCount = lineCount + 1
        if lineCount > self.lines then
            break
        end
        if #line ~= self.lineWidth then 
            error("line " .. lineCount .. " is not 30 characters wide")
        end
        if #string.match(line, self.matchExpr) ~= #line then
            error("line " .. lineCount .. " contains illegal characters")
        end
        if string.find(line, self.spawnChar) then
            spawnPoints = spawnPoints + #string.match(line, '[S]+')
        end
    end
    if lineCount ~= self.lines then 
        error("got " .. lineCount .. " lines, expected " .. self.lines)
    end
    if spawnPoints ~= self.spawns then
        error("got " .. spawnPoints .. " spawns, expected " .. self.spawns)
    end
end

return LevelGenerator
