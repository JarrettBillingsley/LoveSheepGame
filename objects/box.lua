local function _hit(self, type, col)
	if type == 'slam' then
		self.state = 'slammed'
		self.vx = ((math.random() * 30) - 15) * PER_FRAME
		self.vy = -10 * PER_FRAME
		Object_SetNotCollidable(self)
	end
end

function Obj_Box(self, dt)
	if self.state == 'init' then
		self.state = 'main'
		self.hit = _hit
		Object_SetCollidable(self, 'all', TILE_SIZE, TILE_SIZE)
	end

	if self.state == 'slammed' then
		self.vy = self.vy + Gravity * dt
		self.x = self.x + self.vx * dt
		self.y = self.y + self.vy * dt

		if Object_DeleteIfOffscreen(self) then
			return
		end
	end
end
