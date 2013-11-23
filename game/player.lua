local Player = {}
Player.__index = Player

setmetatable(Player, {
	__call = function (cls, ...)
		return cls.init(...)
	end,
})

function Player.init(id, posx, posy)
	-- Create player
	local player = {
		id = id,
		position = {x = posx, y = posy},
		direction = {x = 1, y = 0},
		movement = {x = 0, y = 0},
		radius = 16,
		dead = false,
		is_shooting = false,
		time_since_shot = 0,
		shots = {},
	}
	setmetatable(player, Player)
	return player
end

function Player:kill()

	-- Set dead
	self.dead = true
end

function Player:joystickreleased(key)
	if key == 6 then
		self.is_shooting = false
	end
end

function Player:joystickpressed(key)
	if key == 6 then
		self.is_shooting = true
	end
end

function Player:keyreleased(key)
    if key == "w" then
        self.movement.y = self.movement.y+128
    elseif key == "a" then
        self.movement.x = self.movement.x+128
    elseif key == "s" then
        self.movement.y = self.movement.y-128
    elseif key == "d" then
        self.movement.x = self.movement.x-128
    elseif key == " " then
        self.is_shooting = false
    end
end	

function Player:keypressed(key)
    if key == "w" then
        self.movement.y = self.movement.y-128
    elseif key == "a" then
        self.movement.x = self.movement.x-128
    elseif key == "s" then
        self.movement.y = self.movement.y+128
    elseif key == "d" then
        self.movement.x = self.movement.x+128
    elseif key == "up" then
        self.direction.y = -1
    elseif key == "left" then
        self.direction.x = -1
    elseif key == "down" then
        self.direction.y = 1
    elseif key == "right" then
        self.direction.x = 1
    elseif key == " " then
        self.is_shooting = true
    end
end	

function Player:update(dt)
	-- Handle input
	if love.joystick.isOpen(self.id) then
		local movement_x, movement_y, _unused, aim_y, aim_x = love.joystick.getAxes(self.id)
		
		local movement_length = math.sqrt(movement_x*movement_x + movement_y*movement_y)
		
		if movement_length > 0.2 then
			self.position.x = self.position.x + movement_x * dt * 128
			self.position.y = self.position.y + movement_y * dt * 128
		end
		
		local aim_length = math.sqrt(aim_x*aim_x + aim_y*aim_y)
	
		if aim_length > 0.2 then
			self.direction.x = aim_x / aim_length
			self.direction.y = aim_y / aim_length
		end
	end

	self.position.x = self.position.x + self.movement.x * dt
	self.position.y = self.position.y + self.movement.y * dt
	
	local collision, new_position = level:checkCollisions(self.position, self.radius, true)
	
	if collision then
		self.position = new_position
	end
	
	local direction_length = math.sqrt(self.direction.x*self.direction.x + self.direction.y*self.direction.y)
	
	self.direction.x = self.direction.x / direction_length
	self.direction.y = self.direction.y / direction_length
	
	if self.is_shooting then
		if self.time_since_shot >= 0.03 then
			-- Spawn shot
			shots[#shots+1] = Shot({x = self.position.x + self.direction.x * self.radius, y = self.position.y + self.direction.y * self.radius}, {x = self.direction.x * gridSize * 12, y = self.direction.y * gridSize * 12})
			self.time_since_shot = 0
		end
	end
	
	self.time_since_shot = self.time_since_shot + dt
	
	
end

function Player:draw()
	love.graphics.setColor(colors.bodyColor.r, colors.bodyColor.g, colors.bodyColor.b)
	love.graphics.circle("fill", self.position.x, self.position.y, self.radius, 32)
	
	-- Draw direction
	love.graphics.setColor(255, 0, 0)
	love.graphics.circle("fill", self.position.x + self.direction.x * self.radius, self.position.y + self.direction.y * self.radius, 4, 32)
	
end

return Player
