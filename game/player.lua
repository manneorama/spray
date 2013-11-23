local Player = {}
Player.__index = Player

setmetatable(Player, {
	__call = function (cls, ...)
		return cls.init(...)
	end,
})

function Player.init(id)
	-- Create player
	local player = {
		id = id,
		position = {x = 32, y = 32},
		radius = 16,
		dead = false,
	}
	setmetatable(player, Player)
	return player
end

function Player:kill()

	-- Set dead
	self.dead = true
end

function Player:joystickpressed(key)
	
end

function Player:keypressed(key)
	
end	

function Player:update(dt)
	-- Handle input
	local movement_x, movement_y, _unused, aim_x, aim_y = love.joystick.getAxes(self.id)
	
	self.position.x = self.position.x + movement_x * dt * 128
	self.position.y = self.position.y + movement_y * dt * 128
	
	self.

end

function Player:draw()
	love.graphics.setColor(colors.bodyColor.r, colors.bodyColor.g, colors.bodyColor.b)
	love.graphics.circle("fill", self.position.x, self.position.y, self.radius, 32)
end

return Player