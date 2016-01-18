
local Spritesheet = require 'gfx.enemies.enemies'
local AnimFrames
local IdleAnim, JumpAnim
local JumpDelay = 1
local JumpVelX, JumpVelY = -3 * PER_FRAME, -15 * PER_FRAME

local function _setupAnimFrames(self)
	if not AnimFrames then
		local w, h = Enemy_Texture:getDimensions()

		AnimFrames =
		{
			a = AnimFrame_New(Spritesheet["frame93.png"], w, h),
			b = AnimFrame_New(Spritesheet["frame94.png"], w, h),
		}

		local _, __, colW, colH = AnimFrames.a:getViewport()

		IdleAnim = { AnimMapping(AnimFrames.a, -1, colW, colH, 0, 0), }
		JumpAnim = { AnimMapping(AnimFrames.b, -1, colW, colH, 0, 0), }
	end

	self.img = Enemy_Texture
	self.frame = AnimFrames.a
	Object_ChangeAnim(self, IdleAnim)
	local _, __
	_, __, self.sprW, self.sprH = AnimFrames.a:getViewport()
end

local function _hit(self, type, col)
	if type == 'bottom' then
		if col.slope then
			self.y = col.slope.y - self.colH - 1
			Coll_Update(self, self.x, self.y)
		end

		if self.state == 'jump' then
			self.state = 'main'
			Object_ChangeAnim(self, IdleAnim)
			self.jumpTimer = JumpDelay
			self.isInAir = false
		end
	elseif type == 'top' and self.state == 'jump' then
		self.vy = 0
	elseif type == 'left' or type == 'right' then
		self.sprFlipX = not self.sprFlipX
		self.vx = -self.vx
	end
end

function Obj_Frog(self, dt)
	if self.state == 'init' then
		self.state = 'main'
		self.jumpTimer = JumpDelay
		self.hit = _hit
		_setupAnimFrames(self)
		Object_SetCollidable(self, 'all', self.sprW, self.sprH)
		Coll_Translate(self, 0, TILE_SIZE * 16) -- put on ground
	end

	if self.state == 'main' then
		if Timer0(self, 'jumpTimer', dt) then
			self.state = 'jump'
			Object_ChangeAnim(self, JumpAnim)
			self.vx = JumpVelX
			self.vy = JumpVelY
			self.isInAir = true

			if self.sprFlipX then
				self.vx = -self.vx
			end
		end
	end

	if self.state == 'jump' then
		self.vy = self.vy + Gravity * dt

		local vx, vy = self.vx * dt, self.vy * dt

		if self.beingStoodOn then
			if vy < 0 then
				Object_PlatformMove(self.standingObj, vx, vy)
				Coll_Translate(self, vx, vy)
			else
				Coll_Translate(self, vx, vy)
				Object_PlatformMove(self.standingObj, vx, vy)
			end
		else
			local y = self.y
			Coll_Translate(self, vx, vy)
		end
	end

	Object_Animate(self, dt)
end