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
		movement = {x = 0, y = 0},
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

function Player:keyreleased(key)
	if self.id == 1 then
		if key == "w" then
			self.movement.y = self.movement.y+128
		elseif key == "a" then
			self.movement.x = self.movement.x+128
		elseif key == "s" then
			self.movement.y = self.movement.y-128
		elseif key == "d" then
			self.movement.x = self.movement.x-128
		end
	elseif self.id == 2 then
	
	end
end	

function Player:keypressed(key)
	if self.id == 1 then
		if key == "w" then
			self.movement.y = self.movement.y-128
		elseif key == "a" then
			self.movement.x = self.movement.x-128
		elseif key == "s" then
			self.movement.y = self.movement.y+128
		elseif key == "d" then
			self.movement.x = self.movement.x+128
		end
	elseif self.id == 2 then
	
	end
end	

function Player:update(dt)
	-- Handle input
	local movement_x, movement_y, _unused, aim_x, aim_y = love.joystick.getAxes(self.id)
	
	self.position.x = self.position.x + movement_x * dt * 128
	self.position.y = self.position.y + movement_y * dt * 128

	self.position.x = self.position.x + self.movement.x * dt
	self.position.y = self.position.y + self.movement.y * dt
end

function Player:draw()
	love.graphics.setColor(colors.bodyColor.r, colors.bodyColor.g, colors.bodyColor.b)
	love.graphics.circle("fill", self.position.x, self.position.y, self.radius, 32)
end

return Player