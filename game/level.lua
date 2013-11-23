local LevelGenerator = require "level_generator"

local Level = {}
Level.__index = Level

setmetatable(Level, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})


