local GUI = {}
GUI.__index = GUI

setmetatable(GUI, {
	__call = function (cls, ...)
		return cls.init(...)
	end,
})

function GUI.init()
	-- Create GUI
	local gui = {
		position = { x = 0, y = screenSize.y - gridSize},
		size = { x = screenSize.x, y = gridSize },
	}
	setmetatable(gui, GUI)

	return gui
end

function GUI:draw()
	-- Draw GUI Background
	love.graphics.setColor(colors.guiColor.r, colors.guiColor.g, colors.guiColor.b)
	love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)
end

return GUI