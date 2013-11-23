local level = require "level"

local LevelGenerator = {}
LevelGenerator.__index = LevelGenerator

setmetatable(LevelGenerator, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

function LevelGenerator.new()
    local self = setmetatable({}, LevelGenerator)
    return self
end

function LevelGenerator:parse_level(filename)
    fp = 
end


