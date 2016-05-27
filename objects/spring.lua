local Spring_Spritesheet = require 'gfx.spritesheet_tiles'
local Spring_BounceVel = 40 * PER_FRAME
local Spring_SuperBounceVel = 1.4 * Spring_BounceVel
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

local function _hit(self, type, col)
	if type == 'slam' and self.state == 'main' then
		Player_Spring(-Spring_SuperBounceVel)
		self.frame = Spring_Frames.sprung
		self.timer = Spring_BoingTime
	end
end

function Obj_Spring(self, dt)
	if self.state == 'init' then
		_setupFrames(self)
		self.hit = _hit
		self.state = 'main'
		self.y = self.y + 64
		self.sprW, self.sprH = TILE_SIZE, 64
		self.sprOffsY = -64
		Object_SetCollidable(self, 'all', 'statics', Coll_Flags.None, TILE_SIZE, 64)
		self.timer = 0
	end

	if self.state == 'main' then
		if self.timer then
			if Timer0(self, 'timer', dt) then
				self.frame = Spring_Frames.idle
			end
		end

		if self.beingStoodOn then
			local other = self.standingObj
			Object_StandOn(other, nil)
			Player_Spring(-Spring_BounceVel)
			self.frame = Spring_Frames.sprung
			self.timer = Spring_BoingTime
		end
	end
end
