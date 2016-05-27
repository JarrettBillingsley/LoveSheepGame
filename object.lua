local GX = love.graphics
local floor = math.floor

------------------------------------------------------------------------------------------------------------------------
-- Lifetime
------------------------------------------------------------------------------------------------------------------------

function Object_New(type)
	if ObjectTypes[type] == nil then
		error("invalid object type '" .. tostring(type) .. "'")
	end

	local ret = {
		type = type,
		state = 'init',
		isObject = true,
		x = 0,
		y = 0,
		vx = 0,
		vy = 0,

		-- Collision
		colType = false,
		colLayer = false,
		colFlags = false,
		colCheckGround = false,
		colIsPlatform = false,
		isInAir = false,
		colW = 0,
		colH = 0,
		hit = function() end,
		platformMove = function() end,

		-- Sprite
		sprW = 0,
		sprH = 0,
		sprOffsX = 0,
		sprOffsY = 0,
		sprFlipX = false,
		sprFlipY = false,

		-- Animation
		animFlipX = false,
		animFlipY = false,
		animTimer = 0,
		animFrame = 1,
		animTimeScale = 1,
	}

	GameObjects[ret] = true
	NumGameObjects = NumGameObjects + 1
	return ret
end

function Object_Delete(self)
	if self.colType then
		Object_SetNotCollidable(self)
	end

	NumGameObjects = NumGameObjects - 1
	GameObjects[self] = nil
end

function Object_DeleteIfOffscreen(self, border)
	if not Camera_IsOnscreen(self.x, self.y, self.sprW, self.sprH, border) then
		Object_Delete(self)
		return true
	end
end

------------------------------------------------------------------------------------------------------------------------
-- Updating
------------------------------------------------------------------------------------------------------------------------

function Object_UpdateAll(dt)
	for o, _ in pairs(GameObjects) do
		ObjectTypes[o.type](o, dt)
	end
end

------------------------------------------------------------------------------------------------------------------------
-- Drawing
------------------------------------------------------------------------------------------------------------------------

function Object_Draw(self)
	if self.img and self.frame then
		local flipX = self.sprFlipX ~= self.animFlipX
		local flipY = self.sprFlipY ~= self.animFlipY
		local x = floor(self.x + self.sprOffsX)
		local y = floor(self.y + self.sprOffsY)

		if flipX then
			if flipY then
				GX.draw(self.img, self.frame, x + self.sprW, y + self.sprH, 0, -1, -1)
			else
				GX.draw(self.img, self.frame, x + self.sprW, y, 0, -1, 1)
			end
		elseif flipY then
			GX.draw(self.img, self.frame, x, y + self.sprH, 0, 1, -1)
		else
			GX.draw(self.img, self.frame, x, y)
		end
	end

	if self.drawExtra then
		self:drawExtra()
	end
end

function Object_DrawAll()
	for o, _ in pairs(GameObjects) do
		if o ~= Player then
			Object_Draw(o)
		end
	end

	Object_Draw(Player)
end

------------------------------------------------------------------------------------------------------------------------
-- Collision
------------------------------------------------------------------------------------------------------------------------

function Object_SetCollidable(self, type, layer, flags, w, h)
	self.colFlags = flags
	self.colW, self.colH = w, h

	if self.colType then
		if self.colLayer ~= layer then
			Coll_ChangeLayer(self, layer)
			self.colLayer = layer
		end

		self.colType = type
		Coll_Update(self, self.x, self.y, w, h)
	else
		self.colType = type
		self.colLayer = layer
		Coll_Add(self, self.x, self.y, self.colW, self.colH)
	end
end

function Object_SetNotCollidable(self)
	if self.colType then
		Coll_Remove(self)
		self.colType = false
	end
end

function Object_StandOn(self, o)
	if self.standingObj then
		self.standingObj.beingStoodOn = false
		self.standingObj.standingObj = nil
		self.standingObj = nil
	end

	if o then
		self.standingObj = o
		o.standingObj = self
		o.beingStoodOn = true
	end
end

function Object_CheckStandOn(self, o)
	if o.isObject then
		Object_StandOn(self, o)
	else
		Object_StandOn(self, nil)
	end
end

function Object_PlatformMove(self, dX, dY)
	if self.beingStoodOn then
		if dY < 0 then
			self.x = self.x + dX
			self.y = self.y + dY
			-- self.standingObj:platformMove(dX, dY)
			-- Coll_Translate(self, dX, dY)
		else
			-- Coll_Translate(self, dX, dY)
			-- self.standingObj:platformMove(dX, dY)
			self.x = self.x + dX
			self.y = self.y + dY
		end
	else
		-- Coll_Translate(self, dX, dY)
		self.x = self.x + dX
		self.y = self.y + dY
	end
end

------------------------------------------------------------------------------------------------------------------------
-- Animation
------------------------------------------------------------------------------------------------------------------------

function Object_SetFrame(self, frame)
	self.animFrame = frame
	local f = self.anim[frame]
	self.animTimer, self.frame = f.time, f.frame
	self.animFlipX, self.animFlipY = f.flipX, f.flipY
	self.sprOffsX, self.sprOffsY = f.offsX, f.offsY

	if self.colType and (self.colW ~= f.colW or self.colH ~= f.colH) then
		self.colW, self.colH = f.colW, f.colH
		Coll_Update(self, self.x, self.y, self.colW, self.colH)
	end
end

function Object_ChangeAnim(self, anim)
	if self.anim ~= anim then
		self.anim = anim
		Object_SetFrame(self, 1)
	end
end

function Object_Animate(self, dt)
	if self.animTimer > 0 and Timer0(self, "animTimer", dt * self.animTimeScale) then
		Object_SetFrame(self, IncWrap(self.animFrame, 1, #self.anim))
	end
end

function AnimFrame_New(info, imgWidth, imgHeight)
	return GX.newQuad(info.x, info.y, info.width, info.height, imgWidth, imgHeight)
end

function AnimMapping(frame, time, colW, colH, offsX, offsY, flipX, flipY)
	if flipX == nil then
		flipX = false
	end

	if flipY == nil then
		flipY = false
	end

	return {
		frame = frame,
		time  = time,
		colW  = colW,
		colH  = colH,
		offsX = offsX or 0,
		offsY = offsY or 0,
		flipX = flipX,
		flipY = flipY,
	}
end