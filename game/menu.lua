local Menu = {}
Menu.__index = Menu

setmetatable(Menu, {
	__call = function (cls, ...)
		return cls.init(...)
	end,
})

function Menu.init()
	-- Create Menu
	local menu = {
		activeItem = 1,
		position = { x = 10, y = 60 },
		distance = 20,
		items = {}
	}

	setmetatable(menu, Menu)

	-- Add items to menu
	menu:addItems()

	return menu
end

function Menu:addItems()
	-- Start game item
	self.items[1] = {
		text = "Start game",
		execute = function(key)
			if key == "return" then
				startNewGame()
			end
		end
	}

	-- Quit item
	self.items[2] = {
		text = "Quit",
		execute = function(key)
			if key == "return" then
				love.event.quit()
			end
		end
	}
end

function Menu:keypressed(key)
	-- Take care of self input
	if key == "up" then
		-- Move active up
		self.activeItem = self.activeItem - 1

	elseif key == "down" then
		-- Move active down
		self.activeItem = self.activeItem + 1
	else 
		-- Execute item
		self.items[self.activeItem].execute(key)
	end

	-- Check so that active item is legit
	if self.activeItem <= 0 then
		self.activeItem = table.getn(self.items)
	end
	if self.activeItem > table.getn(self.items) then
		self.activeItem = 1
	end
end

function Menu:draw()

	-- Draw title
	love.graphics.setColor(colors.titleColor.r, colors.titleColor.b, colors.titleColor.g)
	love.graphics.setFont(fonts.bigFont)
	love.graphics.print(texts.titleText, 10, 10)

	-- Draw menu items
	love.graphics.setFont(fonts.smallFont)

	for i = table.getn(self.items), 1, -1 do
		if i == self.activeItem then
			love.graphics.setColor(colors.menuActiveColor.r, colors.menuActiveColor.b, colors.menuActiveColor.g)
		else
			love.graphics.setColor(colors.menuColor.r,colors.menuColor.b, colors.menuColor.g)
		end

		love.graphics.print(self.items[i].text, self.position.x, self.position.y + (i-1) * self.distance)
	end
end

return Menu