
-- Require "class" definitions
Player = require "player"
Shot = require "shot"
Menu = require "menu"
GUI = require "gui"
Level = require "level"

----------------------------------------------
------ CALLBACK FUNCTIONS --------------------
----------------------------------------------

function love.load()
	print("Load started...")
	-- Set Graphic Stuff
	gridSize = 32
	screenSize = { x = gridSize*30, y = gridSize*20}
	love.graphics.setMode(screenSize.x, screenSize.y)

	-- Sounds
	sounds = {
	}
	
	-- Fonts
	fonts = {
		bigFont = love.graphics.newFont("BulkyPixels.ttf", 32),
		smallFont = love.graphics.newFont("BulkyPixels.ttf", 16)
	}

	-- Texts
	texts = {
		deadText = "GAME OVER! (press 'R' to retry)",
		pausedText = "GAME PAUSED! (press 'P' to resume)",
		titleText = "SPRAY - v0.1"
	}
	
	love.graphics.setCaption(texts.titleText)

	-- Colors
	colors = {
		bodyColor = {r = 164, g = 164, b = 164},
		textColor = {r = 255, g = 255, b = 255},
		menuColor = {r = 160, g = 160, b = 160},
		menuActiveColor = {r = 255, g = 255, b = 255},
		titleColor = {r = 255, g = 255, b = 255},
		guiColor = {r = 0, g = 0, b = 0},
        wallColor = {r = 0, g = 0, b = 0},
        floorColor = {r = 255, g = 255, b = 255}
	}
	
	-- Set mode
	game = {
		mode = "menu",
		maxDifficulty = 5,
		difficulty = 2
	}

	-- Create menu
	menu = Menu()

	-- Create gui
	gui = GUI()

	print("Load finished...")
end

function love.joystickreleased(joystick, key)
	if joystick == 1 then
		players[1]:joystickreleased(key)
	end
end

function love.joystickpressed(joystick, key)
	if joystick == 1 then
		players[1]:joystickpressed(key)
	end
end

function love.keyreleased(key)
	if game.mode == "playing" then
		-- Handle player input
		if not game.paused then
            players[2]:keyreleased(key)
		end
	end
end

function love.keypressed(key)
	-- Take care of input, if playing
	if game.mode == "playing" then
		-- Handle player input
		if not game.paused then
            players[2]:keypressed(key)
		end

		-- Restart game
		if key == "r" then
			startNewGame()
		end
	elseif game.mode == "menu" then
		-- Handle menu input
		menu:keypressed(key)
	end

	-- Pause game
	if key == "p" then
		pauseGame()
	end
	
	-- Quit game
	if key == 'escape' then
		if game.mode == "playing" then
			goToMenu()
		else
			love.event.quit()
		end
	end
end

function love.focus(f)
	-- If playing and unfocused, then pause
	if game.mode == "playing" and not f then
		pauseGame()
	end
end

function love.update(dt)
	if game.mode == "playing" then
		if not game.paused then
			for i, player in ipairs(players) do
				player:update(dt)
			end
			
			for i=#shots, 1, -1 do
				shots[i]:update(dt)
				if shots[i].collided then
					table.remove(shots, i)
				end
			end
		end
	end
end

function love.draw()
	if game.mode == "menu" then
		-- Draw menu
		menu:draw()

	elseif game.mode == "playing" then
        -- draw level
        level:draw()

		-- Draw SNAKE
		local player_dead = false
		for i, player in ipairs(players) do
			player:draw()
			if player.dead then
				player_dead = true
			end
		end
		
		-- Shots
		for i, shot in ipairs(shots) do
			shot:draw()
		end
		
		-- Draw GUI
		gui:draw()

		-- Draw dead screen
		if player_dead then
			love.graphics.setColor(colors.textColor.r, colors.textColor.g, colors.textColor.b)
			love.graphics.setFont(fonts.bigFont)
			love.graphics.printf(texts.deadText, screenSize.x/4, screenSize.y/4, screenSize.x/2, "center")
		end
		
		-- Draw paused screen
		if game.paused then
			love.graphics.setColor(colors.textColor.r, colors.textColor.g, colors.textColor.b)
			love.graphics.setFont(fonts.bigFont)
			love.graphics.printf(texts.pausedText, screenSize.x/4, screenSize.y/4, screenSize.x/2, "center")
		end
	end
end

----------------------------------------------
------ NON-CALLBACK FUNCTIONS ----------------
----------------------------------------------

function startNewGame()
    level = Level()
    level:get('test')
    local spawns = level:getSpawnPoints()

	-- Create player
	players = {
		Player(1, spawns[1].x, spawns[1].y, true),
		Player(2, spawns[2].x, spawns[2].y, false),
	}
	
	shots = {}
	

	-- Set gamestate stuff
	game.paused = false
	game.mode = "playing"

	-- Start background sound
	stopSounds()
end

function goToMenu()
	-- Abort sounds/music/whatnot
	stopSounds()
	game.mode = "menu"
end

function doCollisions()
	-- Check if collision with game area
	
	-- Check if collision with body
	
	-- Check if eating APPLE

end


function pauseGame()
	-- If not dead then pause/unpause
	if game.mode == "playing" and not game.paused then
		game.paused = true
	elseif game.mode == "playing" and game.paused then
		game.paused = false
	end
end

function stopSounds()
	for k in pairs(sounds) do
		sounds[k]:stop()
	end
end
