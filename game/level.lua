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
    self.levelTable = nil
    return self
end

function Level:get(levelname)
    -- load level
    local filename = 'levels/' .. levelname .. '.level'
    self.levelTable = LevelGenerator():parseLevel(filename)
end

function Level:draw()
    -- do epic shit
    for i, levelRow in ipairs(self.levelTable) do
        for j = 1, #levelRow do
            local c = levelRow:sub(j,j)
            if c == 'X' then
                love.graphics.setColor(colors.wallColor.r, colors.wallColor.g, colors.wallColor.b)        
            elseif c == 'O' or c == 'S' then
                love.graphics.setColor(colors.floorColor.r, colors.floorColor.g, colors.floorColor.b)
            end
            love.graphics.rectangle("fill", (j-1)*gridSize, (i-1)*gridSize, gridSize, gridSize)
			
        end
    end
end

function Level:checkCollisions(coords, radius)
    local xposmin = math.floor((coords.x - radius)/gridSize)
    local xposmax = math.floor((coords.x + radius)/gridSize)
    local yposmin = math.floor((coords.y - radius)/gridSize)
    local yposmax = math.floor((coords.y + radius)/gridSize)

	local collisions = {}
    local collision = false
	local new_position = coords
    
    for i=yposmin, yposmax do
        local levelRow = self.levelTable[i+1]
        for j=xposmin, xposmax do
            local tile = levelRow:sub(j+1,j+1)
            if tile == 'X' then
                collision = true
				collisions[#collisions+1] = {x = j+1, y = i+1}
            end
        end
    end
	
    return collision, self:findNewPosition(collisions, coords, radius)
end

function Level:findNewPosition(collisions, curPosition, radius)
    local gridx = math.floor(curPosition.x/gridSize) + 1
    local gridy = math.floor(curPosition.y/gridSize) + 1
	
	for i, collision_tile in ipairs(collisions) do
		if gridx == collision_tile.x and gridy == collision_tile.y then
		
		elseif gridx ~= collision_tile.x and gridy ~= collision_tile.y then
			
		elseif gridx ~= collision_tile.x then
			if gridx < collision_tile.x then
				curPosition.x = (collision_tile.x-1) * gridSize - radius
			else
				curPosition.x = collision_tile.x * gridSize + radius
			end
		elseif gridy ~= collision_tile.y then
			if gridy < collision_tile.y then
				curPosition.y = (collision_tile.y-1) * gridSize - radius
			else
				curPosition.y = collision_tile.y * gridSize + radius
			end
		end
	end
	
    return curPosition
end

function Level:getSpawnPoints()
    if self.spawnPositions then return self.spawnPositions end

    local spawns = {}
    for i, row in ipairs(self.levelTable) do
        s, e = row:find('S')
        if s then
            table.insert(spawns, {y = i*gridSize, x = s*gridSize})
        end
    end

    self.spawnPositions = spawns
    return spawns
end

return Level
