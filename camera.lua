local gamera = require 'ext.gamera'

local floor = math.floor
local GX = love.graphics
local KB = love.keyboard

local cam
local Camera_LBound, Camera_RBound, Camera_TBound, Camera_BBound =
	{ colType = 'all', colLayer = 'cambounds' },
	{ colType = 'all', colLayer = 'cambounds' },
	{ colType = 'all', colLayer = 'cambounds' },
	{ colType = 'all', colLayer = 'cambounds' }

local Camera_ShiftX, Camera_ShiftY = 0, 0
local Camera_L, Camera_T, Camera_W, Camera_H = 0, 0, 1, 1

function Camera_Init(color, w, h)
	GX.setBackgroundColor(0, 0, 0) -- unpack(color))
	Camera_W, Camera_H = w, h
	cam = gamera.new(0, 0, w, h)
	cam:setScale(0.5)
	Coll_Add(Camera_LBound, 0, 0, 1, 1)
	Coll_Add(Camera_RBound, 0, 0, 1, 1)
	Coll_Add(Camera_TBound, 0, 0, 1, 1)
	Coll_Add(Camera_BBound, 0, 0, 1, 1)
end

function Camera_Update(dt)
	if KB.isDown('e') then cam:setScale(clamp(cam:getScale() * 1.012, 0.3333, 1)) end
	if KB.isDown('q') then cam:setScale(clamp(cam:getScale() / 1.012, 0.3333, 1)) end
	cam:setPosition(floor(Player.x + Camera_ShiftX), floor(Player.y + Camera_ShiftY))

	local x1,y1, x2,y2, x3,y3, x4,y4 = cam:getVisibleCorners()
	local w = x2 - x1
	local h = y4 - y1

	Camera_L, Camera_T, Camera_W, Camera_H = x1, y1, w, h

	Coll_Update(Camera_LBound, x1 - 100, y1, 100, h)
	Coll_Update(Camera_RBound, x2, y1, 100, h)
	Coll_Update(Camera_TBound, x1, y1 - 100, w, 100)
	Coll_Update(Camera_BBound, x1, y4, w, 100)
end

local function _drawImpl(x, y, w, h)
	Level_Draw(x, y, w, h)
end

function Camera_Draw()
	cam:draw(_drawImpl)
end

function Camera_SetShift(x, y)
	Camera_ShiftX, Camera_ShiftY = x, y
end

function Camera_GetShift()
	return Camera_ShiftX, Camera_ShiftY
end

function Camera_SetShiftX(x)
	Camera_ShiftX = x
end

function Camera_GetShiftX()
	return Camera_ShiftX
end

function Camera_SetShiftY(y)
	Camera_ShiftY = y
end

function Camera_GetShiftY()
	return Camera_ShiftY
end

function Camera_IsOnscreen(x, y, w, h, border)
	border = border or 0
	local border2 = border * 2
	return RectsOverlap(Camera_L - border, Camera_T - border, Camera_W + border2, Camera_H + border2, x, y, w, h)
end