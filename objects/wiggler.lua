
local Spritesheet = require 'gfx.enemies.enemies'
local AnimFrames
local WiggleAnim

local function _setupAnimFrames(self)
	if not AnimFrames then
		local w, h = Enemy_Texture:getDimensions()

		AnimFrames =
		{
			a = AnimFrame_New(Spritesheet["frame9.png"], w, h),
			b = AnimFrame_New(Spritesheet["frame10.png"], w, h),
		}

		WiggleAnim =
		{
			AnimMapping(AnimFrames.a, 0.1, w, h, 0, 0),
			AnimMapping(AnimFrames.b, 0.1, w, h, 0, 0),
		}
	end

	self.img = Enemy_Texture
	self.frame = AnimFrames.a
	Object_ChangeAnim(self, WiggleAnim)
	local _, __
	_, __, self.sprW, self.sprH = AnimFrames.a:getViewport()
end

function Obj_Wiggler(self, dt)
	if self.state == 'init' then
		self.state = 'main'
		self.y = self.y - TILE_SIZE
		_setupAnimFrames(self)
	end

	if self.state == 'main' then
		self.animTimeScale = (11 - clamp(math.abs(self.x - Player.x) / TILE_SIZE, 1, 10)) / 10
		Object_Animate(self, dt)
	end
end