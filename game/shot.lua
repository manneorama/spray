local Shot = {}
Shot.__index = Shot

setmetatable(Shot, {
	__call = function (cls, ...)
		return cls.init(...)
	end,
})

function Shot.init(pos, vel)

	-- Create player
	local shot = {
		position = {x = pos.x, y = pos.y},
		velocity = {x = vel.x, y = vel.y},
	}
	
	setmetatable(shot, Shot)
	return shot
end

function Shot:update(dt)
	-- Handle input
	self.position.x = self.position.x + self.velocity.x * dt
	self.position.y = self.position.y + self.velocity.y * dt
end

function Shot:draw()
	love.graphics.setColor(math.random(0, 255), math.random(0, 255), math.random(0, 255))
	love.graphics.circle("fill", self.position.x, self.position.y, 4, 16)
end

return Shot