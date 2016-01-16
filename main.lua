require 'globals'
require 'constants'
require 'utils'
require 'camera'
require 'objects.all'
require 'level'
require 'collision'

local GX = love.graphics
local KB = love.keyboard

function love.load()
	GX.setDefaultFilter('nearest', 'nearest')
	Player_Texture = GX.newImage("gfx/spritesheet_players.png")
	Player = Object_New('Obj_Player')
	Level_Load("maps/welcome.lua")
end

function love.update(dt)
	Player.jumpHeld = KB.isDown('space')
	Player.duckHeld = KB.isDown('down')

	if KB.isDown('left') then
		if KB.isDown('right') then
			Player.directionHeld = false
		else
			Player.directionHeld = 'left'
		end
	elseif KB.isDown('right') then
		Player.directionHeld = 'right'
	else
		Player.directionHeld = false
	end

	Level_Update(dt)
	Camera_Update(dt)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'space' then
		Player.jumpPressed = true
	elseif key == 'down' then
		Player.duckPressed = true
	elseif key == 'c' then
		Level_Debug_ToggleDrawCollision()
	elseif key == 'return' then
		Player.debugFreeze = not Player.debugFreeze
	elseif key == "'" then
		Player.debugStep = true
	end
end

function love.draw()
	Camera_Draw()

	GX.setColor(255,255,255)
	GX.print(
		"FPS: " .. love.timer.getFPS() ..'\n'..
		"Objects: " .. NumGameObjects ..'\n'..
		Player.state ..'\n'..
		(Player.vx) .. ', ' .. (Player.vy) ..'\n'..
		tostring(Player.animFlipX) .. ' ' .. tostring(Player.animFlipY) ..'\n'..
		"Standing: " .. ((Player.standingObj and tostring(Player.standingObj.type)) or 'nil') ..'\n'..
		tostring(DBGTEXT)
		,2, 0)
end