local Player = {}
Player.__index = Player

setmetatable(Player, {
	__call = function (cls, ...)
		return cls.init(...)
	end,
})

function Player.init()
	-- Create player
	local player = {
		direction = "right",
		position = {x = 0, y = 0},
		size = {x = gridSize, y = gridSize},
		body = {},
		madness = 0,
		dead = false,
		timeSinceUpdate = 0
	}
	setmetatable(player, Player)
	return player
end

function Player:kill()
	-- Play some sound, do something...
	sounds.death:stop()

	-- Set dead
	self.dead = true
end

function Player:keypressed(key)
	if key == "up" and self.direction ~= "down" and self.direction ~= "up" or 
		key == "down" and self.direction ~= "down" and self.direction ~= "up" or 
		key == "left" and self.direction ~= "right" and self.direction ~= "left" or
		key == "right" and self.direction ~= "right" and self.direction ~= "left" then

		self.direction = key
		self:update()
	end
end	

function Player:update()
	-- Move every part of snake

end

function Player:draw()
	
end

return Player