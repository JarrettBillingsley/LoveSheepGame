local sin = math.sin
local pi = math.pi

local WiggleTime   = 0.5
local WiggleAmount = 5
local WiggleSpeed  = 20
local FallTime     = 1.0
local SagSpeed     = 0.5 * PER_FRAME
local SagDist      = 5
local Gravity      = 1.0 * PER_FRAME_2

function Obj_Bridge(self, dt)
	if self.state == 'init' then
		self.state = 'main'
		self.sprW, self.sprH = TILE_SIZE, 48
		Object_SetCollidable(self, 'top', self.sprW, self.sprH)

		self.timer = 0
	end

	if self.state == 'main' then
		if self.beingStoodOn then
			self.state = 'standing'
			self.timer = FallTime
		elseif self.sprOffsY ~= 0 then
			self.sprOffsY = clamp0(self.sprOffsY - SagSpeed * dt)
		end
	end

	if self.state == 'standing' then
		if not self.beingStoodOn then
			self.state = 'main'
			self.sprOffsX = 0
		else
			if self.sprOffsY < SagDist then
				self.sprOffsY = clampHi(self.sprOffsY + SagSpeed * dt, SagDist)
			end

			if Timer0(self, 'timer', dt) then
				self.sprOffsX = 0
				self.timer = 0.1
				self.state = 'falling'
				self.vy = 0
				self.origY = self.y
			elseif self.timer < WiggleTime then
				self.sprOffsX = sin((WiggleTime - self.timer) * WiggleSpeed * pi) * WiggleAmount
			end
		end
	end

	if self.state == 'falling' then
		if self.timer > 0 and Timer0(self, 'timer', dt) then
			Object_SetNotCollidable(self)
		end

		self.vy = self.vy + Gravity * dt
		self.y = self.y + self.vy * dt

		if Object_DeleteIfOffscreen(self) then
			Object_SetNotCollidable(self)
			return
		end
	end
end
