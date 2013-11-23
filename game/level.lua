local LevelGenerator = require "level_generator"

local Level = {}
Level.__index = Level

setmetatable(Level, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

function Level.new()
    local self = setmetatable({}, Level)
    self.level = {}
    self.spawnPositions = nil
    return self
end

function Level:load(levelname)
    -- load level
    filename = 'levels/' .. levelname '.level'
    self.levelTable = LevelGenerator():parseLevel(filename)
end

function Level:draw()
    -- do epic shit
    for i, levelRow in ipairs(self.levelTable) do
        for j = 1, #levelRow do
            if c == 'X' then
                love.graphics.setColor(colors.wallColor.r, colors.wallColor.g, colors.wallColor.b)        
            elseif c == 'O' then
                love.graphics.setColor(colors.floorColor.r, colors.floorColor.g, colors.floorColor.b)
            end
            love.graphics.rectange("fill", j*gridSize, i*gridSize, gridSize, gridSize)
        end
    end
end

function Level:getSpawnPoints()
    if self.spawnPositions then return self.spawnPositions end

    local spawns = {}
    for i, row in ipairs(self.levelTable) do
        s, e = row:find('S')
        table.insert(spawns, {y = i, x = s})
    end

    self.spawnPositions = spawns
    return spawns
end

return Player
