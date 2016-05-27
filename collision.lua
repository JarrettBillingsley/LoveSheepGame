local bump = require 'ext.bump'

local abs = math.abs
local GX = love.graphics

local Coll_CellSize = TILE_SIZE * 4
local Coll_GroundCheckDelta = 4
local _world
local _collisionLayers

Coll_Flags =
{
	None = { statics = false, dynamics = false, cambounds = false, platforms = false },
	S    = { statics = true,  dynamics = false, cambounds = false, platforms = false },
	D    = { statics = false, dynamics = true,  cambounds = false, platforms = false },
	C    = { statics = false, dynamics = false, cambounds = true,  platforms = false },
	SD   = { statics = true,  dynamics = true,  cambounds = false, platforms = false },
	SC   = { statics = true,  dynamics = false, cambounds = true,  platforms = false },
	DC   = { statics = false, dynamics = true,  cambounds = true,  platforms = false },
	SDC  = { statics = true,  dynamics = true,  cambounds = true,  platforms = false },
	P    = { statics = false, dynamics = false, cambounds = false, platforms = true  },
	SP   = { statics = true,  dynamics = false, cambounds = false, platforms = true  },
	DP   = { statics = false, dynamics = true,  cambounds = false, platforms = true  },
	CP   = { statics = false, dynamics = false, cambounds = true,  platforms = true  },
	SDP  = { statics = true,  dynamics = true,  cambounds = false, platforms = true  },
	SCP  = { statics = true,  dynamics = false, cambounds = true,  platforms = true  },
	DCP  = { statics = false, dynamics = true,  cambounds = true,  platforms = true  },
	SDCP = { statics = true,  dynamics = true,  cambounds = true,  platforms = true  },
}

------------------------------------------------------------------------------------------------------------------------
-- Custom responses
------------------------------------------------------------------------------------------------------------------------

local function _commonSlide(world, col, x,y,w,h, goalX, goalY, filter)
	goalX = goalX or x
	goalY = goalY or y

	local tch, move  = col.touch, col.move
	local sx, sy     = tch.x, tch.y
	if move.x ~= 0 or move.y ~= 0 then
		if col.normal.x == 0 then
			sx = goalX
		else
			sy = goalY
		end
	end

	x,y          = tch.x, tch.y
	goalX, goalY = sx, sy
	local cols, len  = world:project(col.item, x,y,w,h, goalX, goalY, filter)
	return goalX, goalY, cols, len
end

local function _top(world, col, x,y,w,h, goalX, goalY, filter)
	if col.normal.y ~= -1 or col.overlaps then
		col.type = 'cross'
		local cols, len = world:project(col.item, x,y,w,h, goalX, goalY, filter)
		return goalX, goalY, cols, len
	else
		col.type = 'slide'
		return _commonSlide(world, col, x,y,w,h, goalX, goalY, filter)
	end
end

local function _slopeUp(world, col, x,y,w,h, goalX, goalY, filter)
	if col.overlaps or col.normal.x == -1 or col.normal.y == -1 then
		goalX = goalX or x
		goalY = goalY or y

		local touch = col.touch
		local sx, sy = touch.x, touch.y
		local r, b = goalX + w, goalY + h
		local slopeL, slopeT = col.otherRect.x, col.otherRect.y
		local slopeR, slopeB = slopeL + col.otherRect.w, slopeT + col.otherRect.h

		if r > slopeR then
			sx = goalX
			sy = slopeT - h
			col.slope = { y = slopeT, onSlope = true }
		elseif not col.overlaps and b > slopeB then
			col.type = 'slide'
			sy = goalY
		else
			sx = goalX
			local slopeY = slopeT + TILE_SIZE - clamp(r - slopeL, 0, TILE_SIZE)
			col.slope = { y = slopeY }

			if b >= slopeY then
				sy = slopeY - h
				col.slope.onSlope = true
			else
				sy = goalY
				col.slope.onSlope = false
			end
		end

		x, y = sx, sy
		goalX, goalY = sx, sy
		return goalX, goalY, world:project(col.item, x,y,w,h, goalX, goalY, filter)
	else
		col.type = 'slide'
		return _commonSlide(world, col, x,y,w,h, goalX, goalY, filter)
	end
end

local function _slopeDn(world, col, x,y,w,h, goalX, goalY, filter)
	if col.overlaps or col.normal.x == 1 or col.normal.y == -1 then
		goalX = goalX or x
		goalY = goalY or y

		local touch = col.touch
		local sx, sy = touch.x, touch.y
		local b = goalY + h
		local slopeL, slopeT = col.otherRect.x, col.otherRect.y
		local slopeR, slopeB = slopeL + col.otherRect.w, slopeT + col.otherRect.h

		if goalX <= slopeL then
			sx = goalX
			sy = slopeT - h
			col.slope = { y = slopeT, onSlope = true }
		elseif not col.overlaps and b > slopeB then
			col.type = 'slide'
			sy = goalY
		else
			sx = goalX
			local slopeY = slopeT + clamp(goalX - slopeL, 0, TILE_SIZE)
			col.slope = { y = slopeY }

			if b >= slopeY then
				sy = slopeY - h
				col.slope.onSlope = true
			else
				sy = goalY
				col.slope.onSlope = false
			end
		end

		x, y = sx, sy
		goalX, goalY = sx, sy
		return goalX, goalY, world:project(col.item, x,y,w,h, goalX, goalY, filter)
	else
		col.type = 'slide'
		return _commonSlide(world, col, x,y,w,h, goalX, goalY, filter)
	end
end

local _colTypeMapping =
{
	all = 'slide',
	top = 'top',
	slope_up = 'slope_up',
	slope_dn = 'slope_dn',
}

local function _getColType(self)
	return self.colType
end

local function _colFilter(self, other)
	if other.isCamBound or self.beingStoodOn and other == self.standingObj then
		return nil
	end

	local type = _getColType(other)

	if type then
		return _colTypeMapping[type]
	else
		return nil
	end
end

local function _playerColFilter(self, other)
	local type = _getColType(other)

	if type then
		return _colTypeMapping[type]
	else
		return nil
	end
end

local function _getColFilter(self)
	if self == Player then
		return _playerColFilter
	else
		return _colFilter
	end
end

------------------------------------------------------------------------------------------------------------------------
-- Collision responses
------------------------------------------------------------------------------------------------------------------------

local function _slide(self, col)
	if not self.isInAir then
		if abs(col.move.x) > abs(col.move.y) then
			if col.normal.x < 0 and self.vx > 0 then
				self:hit('right', col)
			elseif col.normal.x > 0 and self.vx < 0 then
				self:hit('left', col)
			end
		end

		if col.normal.y < 0 then
			self:hit('bottom', col)
		end
	else
		if col.normal.x < 0 and self.vx > 0 then
			self:hit('right', col)
		elseif col.normal.x > 0 and self.vx < 0 then
			self:hit('left', col)
		elseif col.normal.y > 0 and self.vy < 0 then
			self:hit('top', col)
		elseif col.normal.y < 0 and self.vy > 0 then
			self:hit('bottom', col)
		end
	end
end

local function _slope(self, col)
	if col.slope.onSlope or not self.isInAir then
		self:hit('bottom', col)
	end
end

local function _cross(self, col)
	self:hit('cross', col)
end

local Coll_Responses =
{
	slide = _slide,
	slope_up = _slope,
	slope_dn = _slope,
	cross = _cross,
}

local function _respondToColl(self, col)
	local resp = Coll_Responses[col.type]

	if resp then
		return resp(self, col)
	else
		return false
	end
end

------------------------------------------------------------------------------------------------------------------------
-- Public interface
------------------------------------------------------------------------------------------------------------------------

function Coll_Init(map)
	_collisionLayers =
	{
		statics = {},
		dynamics = {},
		platforms = {},
		cambounds = {},
	}

	_world = bump.newWorld(Coll_CellSize)
	_world:addResponse('top', _top)
	_world:addResponse('slope_up', _slopeUp)
	_world:addResponse('slope_dn', _slopeDn)
	map:mybump_init(_world)
end

function Coll_Add(self, x, y, w, h)
	_collisionLayers[self.colLayer][self] = true
	_world:add(self, x, y, w, h)
end

function Coll_Remove(self)
	_collisionLayers[self.colLayer][self] = nil
	_world:remove(self)
end

function Coll_ChangeLayer(self, newLayer)
	_collisionLayers[self.colLayer][self] = nil
	_collisionLayers[newLayer][self] = true
end

function Coll_Update(self, x, y, w, h)
	return _world:update(self, x, y, w, h)
end

function Coll_Translate(self, dX, dY)
	local oldX, oldY = _world:getRect(self)

	if _getColType(self) == 'top' and dY >= 0 then
		self.x, self.y = oldX + dX, oldY + dY
		_world:update(self, self.x, self.y)
	else
		local cols, len
		self.x, self.y, cols, len = _world:move(self, oldX + dX, oldY + dY, _getColFilter(self))

		for i = 1, len do
			_respondToColl(self, cols[i])
		end
	end
end

function Coll_Check(self, dX, dY)
	local _, _, cols, len = _world:check(self, self.x + dX, self.y + dY, _getColFilter(self))

	for i = 1, len do
		_respondToColl(self, cols[i])
	end
end

local function _theColFilter(self, other)
	if self.colFlags[other.colLayer] then
		local type = _getColType(other)

		if type then
			return _colTypeMapping[type]
		end
	end
end

function _stickToGround(self, col)
	local oldY = self.y

	if col.slope then
		self.y = col.slope.y - self.colH
	elseif col.type == 'slide' then
		self.y = col.otherRect.y - self.colH
	end

	if self.y ~= oldY then
		Coll_Update(self, self.x, self.y)
	end

	Object_CheckStandOn(self, col.other)
end

function Coll_UpdateDynamics(dt)
	for obj, _ in pairs(_collisionLayers.dynamics) do
		if obj.colIsPlatform then
			if obj.beingStoodOn then
				local oldX, oldY = _world:getRect(obj)
				local dX, dY = obj.x - oldX, obj.y - oldY
				local other = obj.standingObj
				other.x, other.y = other.x + dX, other.y + dY
				_world:update(other, other.x, other.y)
			end

			_world:update(obj, obj.x, obj.y)
		else
			local cols, len
			obj.x, obj.y, cols, len = _world:move(obj, obj.x, obj.y, _theColFilter)

			for i = 1, len do
				_respondToColl(obj, cols[i])
			end

			if obj.colCheckGround and not obj.isInAir then
				-- Adding the x vel makes it so the faster the object is moving horizontally, the further down we check for
				-- the ground, since they could be going down a slope very quickly
				local testY = obj.y + abs(obj.vx * dt) + Coll_GroundCheckDelta
				local _, newY, cols, testLen = _world:check(obj, obj.x, testY, _theColFilter)

				if testLen == 0 then
					obj.isInAir = true
				else
					_stickToGround(obj, cols[1])
				end
			end
		end
	end
--[[
	for obj, _ in pairs(_collisionLayers.platforms) do

		if obj.beingStoodOn then
			local standingObj = obj.standingObj
			local dX, dY = standingObj.x - obj.x, standingObj.y - obj.y

			local function filter(self, other)
				if other == standingObj then
					return nil
				else
					return _theColFilter(self, other)
				end
			end

			local cols, len

			if _getColType(obj) == 'top' and obj.vy >= 0 then
				obj.x, obj.y = obj.x + obj.vx, obj.y + obj.vy
				_world:update(obj, obj.x, obj.y)
			else
				obj.x, obj.y, cols, len = _world:move(obj, obj.x + obj.vx, obj.y + obj.vy, filter)

				for i = 1, len do
					_respondToColl(obj, cols[i])
				end
			end

			standingObj.x = obj.x + dX
			standingObj.y = obj.y + dY
			_world:update(standingObj, standingObj.x, standingObj.y)
		else
			local cols, len

			if _getColType(obj) == 'top' and obj.vy >= 0 then
				obj.x, obj.y = obj.x + obj.vx, obj.y + obj.vy
				_world:update(obj, obj.x, obj.y)
			else
				obj.x, obj.y, cols, len = _world:move(obj, obj.x + obj.vx, obj.y + obj.vy, _theColFilter)

				for i = 1, len do
					_respondToColl(obj, cols[i])
				end
			end
		end
	end
--]]
end

local _layerColors =
{
	statics =   { 0, 127, 255, 32 },
	dynamics =  { 255, 255, 0, 64 },
	platforms = { 0, 255, 0, 64 },
	stoodOn =   { 255, 0, 0, 32 },
}

function Coll_Debug_DrawRects()
	local items, len = _world:getItems()

	for i = 1, len do
		local item = items[i]
		local l, t, w, h = _world:getRect(item)

		if item.isObject then
			if item.beingStoodOn then
				GX.setColor(unpack(_layerColors.stoodOn))
			else
				GX.setColor(unpack(_layerColors[item.colLayer]))
			end
		else
			GX.setColor(unpack(_layerColors.statics))
		end
		GX.rectangle('fill', l,t,w,h)
		GX.setColor(255, 255, 255, 128)
		GX.rectangle('line', l,t,w,h)
	end
end