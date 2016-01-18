local floor = math.floor
local sign = math.sign

------------------------------------------------------------------------------------------------------------------------
-- Constants
------------------------------------------------------------------------------------------------------------------------

local Player_CollWidth       = 80
local Player_CollHeightStand = 256 - 120
local Player_CollHeightDuck  = 256 - 150
local Player_GroundAccel     = 0.3 * PER_FRAME_2
local Player_GroundSkidAccel = 0.8 * PER_FRAME_2
local Player_GroundFriction  = 0.5 * PER_FRAME_2
local Player_AirAccel        = 0.5 * PER_FRAME_2
local Player_JumpVel         = -13 * PER_FRAME
local Player_MaxWalkVelX     =  10 * PER_FRAME
local Player_MaxAirVelX      =  10 * PER_FRAME
local Player_MinVelY         = -50 * PER_FRAME
local Player_MaxVelY         =  30 * PER_FRAME
local Player_JumpTime        = 0.3
local Player_SlamTime        = 0.2
local Player_SlamVelY        =  40 * PER_FRAME

------------------------------------------------------------------------------------------------------------------------
-- Animations/graphics
------------------------------------------------------------------------------------------------------------------------

local Player_Spritesheet = require 'gfx.spritesheet_players'
local Player_AnimFrames
local Player_Anims

local function _setupAnimFrames(self, texture)
	self.img = texture
	self.sprW, self.sprH = 128, Player_CollHeightStand

	if Player_AnimFrames then
		return
	end

	local w, h = texture:getDimensions()

	Player_AnimFrames =
	{
		climb1 = AnimFrame_New(Player_Spritesheet["alienGreen_climb1.png"], w, h),
		climb2 = AnimFrame_New(Player_Spritesheet["alienGreen_climb2.png"], w, h),
		duck   = AnimFrame_New(Player_Spritesheet["alienGreen_duck.png"  ], w, h),
		front  = AnimFrame_New(Player_Spritesheet["alienGreen_front.png" ], w, h),
		hit    = AnimFrame_New(Player_Spritesheet["alienGreen_hit.png"   ], w, h),
		jump   = AnimFrame_New(Player_Spritesheet["alienGreen_jump.png"  ], w, h),
		stand  = AnimFrame_New(Player_Spritesheet["alienGreen_stand.png" ], w, h),
		swim1  = AnimFrame_New(Player_Spritesheet["alienGreen_swim1.png" ], w, h),
		swim2  = AnimFrame_New(Player_Spritesheet["alienGreen_swim2.png" ], w, h),
		walk1  = AnimFrame_New(Player_Spritesheet["alienGreen_walk1.png" ], w, h),
		walk2  = AnimFrame_New(Player_Spritesheet["alienGreen_walk2.png" ], w, h),
	}

	local af = Player_AnimFrames
	local Width, StandHeight, DuckHeight = Player_CollWidth, Player_CollHeightStand, Player_CollHeightDuck

	Player_Anims =
	{
		idle =
		{	AnimMapping(af.stand, -1.0,  Width, StandHeight, -24, -20), },

		walk =
		{	AnimMapping(af.walk1, 0.25,  Width, StandHeight, -24, -20),
			AnimMapping(af.walk2, 0.25,  Width, StandHeight, -24, -20), },

		jump =
		{	AnimMapping(af.jump, -1.0,   Width, StandHeight, -24, -20), },

		slam =
		{	AnimMapping(af.jump, 0.1,    Width, StandHeight, -24, 20, false, true),
			AnimMapping(af.jump, 0.1,    Width, StandHeight, -24, 20, true, true), },

		duck =
		{	AnimMapping(af.duck, -1.0,   Width, DuckHeight, -24, -50), },

		climb =
		{	AnimMapping(af.climb1, 0.25, Width, StandHeight, -24, -20),
			AnimMapping(af.climb2, 0.25, Width, StandHeight, -24, -20), },

		swim =
		{	AnimMapping(af.swim1, 0.25,  Width, StandHeight, -24, -20),
			AnimMapping(af.swim2, 0.25,  Width, StandHeight, -24, -20), },

		hit =
		{	AnimMapping(af.hit, -1.0,    Width, StandHeight, -24, -20), },
	}
end

local function _changeGroundAnim(self)
	if self.vx == 0 then
		Object_ChangeAnim(self, Player_Anims.idle)
	else
		Object_ChangeAnim(self, Player_Anims.walk)
	end
end

------------------------------------------------------------------------------------------------------------------------
-- Helpers
------------------------------------------------------------------------------------------------------------------------

local function _checkStandingObj(self, o)
	if o.isObject then
		Object_StandOn(self, o)
	else
		Object_StandOn(self, nil)
	end
end

------------------------------------------------------------------------------------------------------------------------
-- State changes
------------------------------------------------------------------------------------------------------------------------

local function _setInAir(self)
	self.state = 'air'
	self.isInAir = true
	Object_StandOn(self, nil)
	Object_ChangeAnim(self, Player_Anims.jump)
end

local function _setJumping(self)
	self.jumpTimer = Player_JumpTime
	self.vy = Player_JumpVel
	_setInAir(self)
end

local function _setGround(self)
	self.state = 'ground'
	self.isInAir = false
	self.vy = 0
	_changeGroundAnim(self)
end

local function _setDucked(self)
	self.state = 'duck'
	self.isInAir = false
	self.y = self.y + (Player_CollHeightStand - Player_CollHeightDuck)
	Object_ChangeAnim(self, Player_Anims.duck)
	Camera_SetShiftY(-30)
end

local function _setSlamming(self)
	self.state = 'slam'
	self.isInAir = true
	self.vx = 0
	self.vy = 0
	self.slamTimer = Player_SlamTime
	Object_ChangeAnim(self, Player_Anims.slam)
end

local function _unduck(self, stateChange)
	self.y = self.y - (Player_CollHeightStand - Player_CollHeightDuck)
	stateChange(self)
	Camera_SetShiftY(0)
end

------------------------------------------------------------------------------------------------------------------------
-- Collision
------------------------------------------------------------------------------------------------------------------------

local function _hit(self, type, col)
	if type == 'left' or type == 'right' then
		self.vx = 0
	elseif type == 'top' then
		self.jumpTimer = 0
		self.vy = 0
	elseif type == 'bottom' then
		local wasSlamming = self.state == 'slam'
		self.isGrounded = true

		if self.isInAir then
			_setGround(self)
		end

		if col.slope then
			self.y = col.slope.y - self.colH
			Coll_Update(self, self.x, self.y)
		end

		_checkStandingObj(self, col.other)

		if wasSlamming and self.standingObj then
			self.standingObj:hit('slam')
		end
	elseif type == 'cross' then

	end
end

local function _platformMove(self, dX, dY)
	if self.state ~= 'ground' then
		return
	end

	Coll_Translate(self, dX, dY)
end

local function _checkAirCollision(self, dt)
	Coll_Translate(self, self.vx * dt, self.vy * dt)
end

local function _checkGroundCollision(self, dt)
	if self.vx ~= 0 then
		Coll_Translate(self, self.vx * dt, 0)
	end
end

local function _checkGrounded(self, dt)
	self.isGrounded = false
	Coll_Check(self, 0, 1)
	return self.isGrounded
end

------------------------------------------------------------------------------------------------------------------------
-- Physics
------------------------------------------------------------------------------------------------------------------------

local function _groundFriction(self, dt)
	if self.vx > 0 then
		self.vx = clamp0(self.vx - Player_GroundFriction * dt)
	elseif self.vx < 0 then
		self.vx = clampHi(self.vx + Player_GroundFriction * dt, 0)
	end
end

local function _groundAccel(self, dt)
	if self.directionHeld then
		local accel

		if self.directionHeld == 'right' then
			if self.vx < Player_MaxWalkVelX then
				if self.vx >= 0 then
					accel = Player_GroundAccel
				else
					accel = Player_GroundSkidAccel
				end

				self.vx = clampHi(self.vx + accel * dt, Player_MaxWalkVelX)
			end
		elseif self.vx > -Player_MaxWalkVelX then
			if self.vx <= 0 then
				accel = -Player_GroundAccel
			else
				accel = -Player_GroundSkidAccel
			end

			self.vx = clampLo(self.vx + accel * dt, -Player_MaxWalkVelX)
		end
	else
		_groundFriction(self, dt)
	end
end

local function _airGravity(self, dt)
	self.vy = clamp(self.vy + Gravity * dt, Player_MinVelY, Player_MaxVelY)
end

local function _airAccel(self, dt)
	if self.jumpTimer > 0 then
		self.jumpTimer = clamp0(self.jumpTimer - dt)

		if not self.jumpHeld then
			self.jumpTimer = 0
		end
	end

	if self.jumpTimer > 0 and self.jumpHeld then
		self.vy = Player_JumpVel
	else
		_airGravity(self, dt)
	end

	if self.directionHeld == 'right' and self.vx < Player_MaxAirVelX then
		self.vx = clampHi(self.vx + Player_AirAccel * dt, Player_MaxAirVelX)
	elseif self.directionHeld == 'left' and self.vx > -Player_MaxAirVelX then
		self.vx = clampLo(self.vx - Player_AirAccel * dt, -Player_MaxAirVelX)
	end
end

------------------------------------------------------------------------------------------------------------------------
-- States
------------------------------------------------------------------------------------------------------------------------

local function _init(self, dt)
	self.hit = _hit
	self.platformMove = _platformMove
	_setupAnimFrames(self, Player_Texture)
	Object_SetCollidable(self, 'all', 1, 1) -- dummy size, set correctly by _setGround
	_setGround(self)

	Coll_Translate(self, 0, TILE_SIZE * 16) -- put on ground
	self.vx, self.vy = 0, 0

	self.duckPressed = false
	self.duckHeld = false
	self.directionHeld = false
	self.jumpPressed = false
	self.jumpHeld = false
	self.jumpTimer = 0

	self.debugFreeze = false
	self.debugStep = false

	return true
end

local function _ground(self, dt)
	if self.jumpPressed then
		_setJumping(self)
		return true
	elseif self.duckHeld then
		_setDucked(self)
		return true
	else
		_groundAccel(self, dt)
		_checkGroundCollision(self, dt)

		if not _checkGrounded(self, dt) then
			_setInAir(self)
			return true
		else
			_changeGroundAnim(self)
		end
	end
end

local function _air(self, dt)
	if self.duckPressed then
		_setSlamming(self)
		return true
	else
		self.jumpPressed = false -- ignore extra jump presses in midair
		_airAccel(self, dt)
		_checkAirCollision(self, dt)

		if self.state == 'air' then
			Object_ChangeAnim(self, Player_Anims.jump)
		end
	end
end

local function _duck(self, dt)
	if not self.duckHeld then
		_unduck(self, _setGround)
		return true
	elseif self.jumpPressed then
		_unduck(self, _setJumping)
		return true
	else
		self.duckPressed = false
		_groundFriction(self, dt)
		_checkGroundCollision(self, dt)

		if not _checkGrounded(self, dt) then
			_unduck(self, _setInAir)
			return true
		end
	end
end

local function _slam(self, dt)
	self.duckPressed = false -- ignore subsequent presses

	if self.slamTimer then
		if Timer0(self, 'slamTimer', dt) then
			self.vy = Player_SlamVelY
		end
	end

	_checkAirCollision(self, dt)

	if self.state == 'slam' then
		Object_ChangeAnim(self, Player_Anims.slam)
	end
end

local Player_States =
{
	init = _init,
	ground = _ground,
	air = _air,
	duck = _duck,
	slam = _slam,
}

------------------------------------------------------------------------------------------------------------------------
-- Public interface
------------------------------------------------------------------------------------------------------------------------

function Obj_Player(self, dt)
	if self.debugFreeze then

		if self.debugStep then
			self.debugStep = false
		else
			return
		end
	end

	for i = 1, 1000 do
		if i == 1000 then
			error('Loop detected in player logic (state = ' .. self.state ..')')
		elseif not Player_States[self.state](self, dt) then
			break
		end
	end

	if self.vx < 0 then
		self.sprFlipX = true
	elseif self.vx > 0 then
		self.sprFlipX = false
	end

	Object_Animate(self, dt)
end

function Player_Spring(vy)
	_setInAir(Player)
	Player.vy = vy
	Player.jumpTimer = 0
end