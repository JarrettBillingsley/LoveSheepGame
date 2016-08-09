require 'globals'
require 'utils'
require 'camera'
require 'objects.all'
require 'level'
require 'collision'

--[[
TODO:

- Change collision so it's sort of layer-based -- then collisions can be performed and resolved in multiple phases

	Collision layers:
	- Player
	- Statics
	- Dynamics
	- Cambounds

	Player -> Statics    (player moving around level)
	Player -> Dynamics   (player interacting with objects)
	Player -> Cambounds  (player hitting edge of screen)
	Dynamics -> Statics  (objects moving around level)
	Dynamics -> Player   (objects interacting with player)
	Dynamics -> Dynamics (objects interacting with each other)

	Is the Player layer necessary? It's basically a dynamic. It does however interact with the cam bounds in a way that
	other objects don't (usually..), and may need special treatment in collision responses..... maybe.............

	Let's start with just Statics, Dynamics, and Cambounds and go from there.

	Each object/tile has:
		- collision layer
		- collision flags (pointer to common tables)

- Make object coords go from center of object instead of top-left corner - makes rotation possible
- Make UI layer that gets drawn in a zoom/resolution-independent manner
- Make objects go dormant when offscreen
- Centralize texture caching (integrate map texture loading into that)
- Simplify/centralize frame/mapping/animation stuff
--]]

local GX = love.graphics
local KB = love.keyboard

function love.load()
	GX.setDefaultFilter('nearest', 'nearest')
	Player_Texture = GX.newImage("gfx/spritesheet_players.png")
	Enemy_Texture = GX.newImage("gfx/enemies/enemies.png")
	Player = Object_New('Obj_Player')
	Level_Load("maps/welcome.lua")
end

function love.update(dt)
	if DBG_Freeze then

		if DBG_Step then
			DBG_Step = false
		else
			return
		end
	end

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
		DBG_Freeze = not DBG_Freeze
	elseif key == "'" then
		DBG_Step = true
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
		DBGTABLE.msg ..'\n'..
		DBGTEXT
		,2, 0)
end