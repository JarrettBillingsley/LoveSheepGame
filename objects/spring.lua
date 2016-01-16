local Spring_Spritesheet = require 'gfx.spritesheet_tiles'
local Spring_BounceVel = 40 * PER_FRAME
local Spring_BoingTime = 0.25
local Spring_Frames

local function _setupFrames(self)
	if Spring_Frames then
		return
	end

	local w, h = self.img:getDimensions()

	Spring_Frames =
	{
		idle   = AnimFrame_New(Spring_Spritesheet['spring.png'], w, h),
		sprung = AnimFrame_New(Spring_Spritesheet['sprung.png'], w, h),
	}
end

function Obj_Spring(self, dt)
	-- BUG: player can jump off top of spring on first frame they collide with it (seems to be fixed??)
	if(self.state == 'init') then
		_setupFrames(self)
		self.state = 'main'
		self.beingStoodOn = false
		self.y = self.y + 64
		self.sprW, self.sprH = TILE_SIZE, 64
		self.sprOffsY = -64
		Object_SetCollidable(self, 'all', TILE_SIZE, 64)
		self.timer = 0
	end

	if(self.state == 'main') then
		if self.timer then
			if Timer0(self, 'timer', dt) then
				self.frame = Spring_Frames.idle
			end
		end

		if(self.beingStoodOn) then
			self.beingStoodOn = false
			Player.state = 'air'
			Player.isInAir = true
			Player.vy = -Spring_BounceVel
			Player.jumpTimer = 0
			Player.standingObj = nil
			self.frame = Spring_Frames.sprung
			self.timer = Spring_BoingTime
		end
	end
end
