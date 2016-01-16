local abs = math.abs

local bump = require 'ext.bump'

local Coll_CellSize = TILE_SIZE * 4
local _world

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

		local tch, move  = col.touch, col.move
		local sx, sy     = tch.x, tch.y
		local r, b = x + w, y + h
		local slopeL, slopeT = col.otherRect.x, col.otherRect.y
		local slopeR, slopeB = slopeL + col.otherRect.w, slopeT + col.otherRect.h

		if r > slopeR then
			sx = goalX
			col.slope = { y = slopeT, onSlope = true }
		elseif b > slopeB then
			col.type = 'slide'
			sy = goalY
		else
			sx = goalX
			local slopeY = slopeT + TILE_SIZE - clamp(r - slopeL, 0, TILE_SIZE)
			col.slope = { y = slopeY }

			if b > slopeY then
				sy = slopeY - h
				col.slope.onSlope = true
			else
				sy = goalY
				col.slope.onSlope = false
			end
		end

		x, y = sx, sy
		goalX, goalY = sx, sy
		local cols, len  = world:project(col.item, x,y,w,h, goalX, goalY, filter)
		return goalX, goalY, cols, len
	else
		col.type = 'slide'
		return _commonSlide(world, col, x,y,w,h, goalX, goalY, filter)
	end
end

local function _slopeDn(world, col, x,y,w,h, goalX, goalY, filter)
	if col.overlaps or col.normal.x == 1 or col.normal.y == -1 then
		goalX = goalX or x
		goalY = goalY or y

		local tch, move  = col.touch, col.move
		local sx, sy     = tch.x, tch.y
		local b = y + h
		local slopeL, slopeT = col.otherRect.x, col.otherRect.y
		local slopeR, slopeB = slopeL + col.otherRect.w, slopeT + col.otherRect.h

		if x <= slopeL then
			sx = goalX
			col.slope = { y = slopeT, onSlope = true }
		elseif b > slopeB then
			col.type = 'slide'
			sy = goalY
		else
			sx = goalX
			local slopeY = slopeT + clamp(x - slopeL, 0, TILE_SIZE)
			col.slope = { y = slopeY }

			if b > slopeY then
				sy = slopeY - h
				col.slope.onSlope = true
			else
				sy = goalY
				col.slope.onSlope = false
			end
		end

		x, y = sx, sy
		goalX, goalY = sx, sy
		local cols, len  = world:project(col.item, x,y,w,h, goalX, goalY, filter)
		return goalX, goalY, cols, len
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
	if self.isObject then
		if self.collidable then
			return self.colType
		else
			return nil
		end
	else
		return self.properties and self.properties.collision_type
	end
end

local function _colFilter(self, other)
	local type = _getColType(other)

	if type then
		return _colTypeMapping[type]
	else
		return nil
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
	_world = bump.newWorld(Coll_CellSize)
	_world:addResponse('top', _top)
	_world:addResponse('slope_up', _slopeUp)
	_world:addResponse('slope_dn', _slopeDn)
	map:mybump_init(_world)
end

function Coll_Add(self, x, y, w, h)
	_world:add(self, x, y, w, h)
end

function Coll_Remove(self)
	_world:remove(self)
end

function Coll_Update(self, x, y, w, h)
	return _world:update(self, x, y, w, h)
end

function Coll_Translate(self, dX, dY)
	local oldX, oldY = _world:getRect(self)
	Coll_Move(self, oldX + dX, oldY + dY)
end

function Coll_Move(self, x, y)
	local cols, len
	self.x, self.y, cols, len = _world:move(self, x, y, _colFilter)

	for i = 1, len do
		_respondToColl(self, cols[i])
	end
end

function Coll_Check(self, dX, dY)
	local _, __, cols, len = _world:check(self, self.x + dX, self.y + dY, _colFilter)

	for i = 1, len do
		_respondToColl(self, cols[i])
	end
end

function Coll_GetRect(self)
	return _world:getRect(self)
end

function Coll_Debug_DrawRects()
	local items, len = _world:getItems()

	for i = 1, len do
		local l, t, w, h = _world:getRect(items[i])

		if items[i].beingStoodOn then
			love.graphics.setColor(255, 0, 0, 32)
		else
			love.graphics.setColor(0, 127, 255, 32)
		end
		love.graphics.rectangle('fill', l,t,w,h)
		love.graphics.setColor(255, 255, 255, 128)
		love.graphics.rectangle('line', l,t,w,h)
	end
end