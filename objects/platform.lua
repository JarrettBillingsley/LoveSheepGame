local Speed = 0.01 * PER_FRAME

local Update =
{
	ud = function(self, dt)
		self.phase = wrap0(self.phase + Speed * dt, 2)

		local oldY = self.y
		local newY = self.initialY + math.sin(self.phase * math.pi) * self.distance
		local dY = newY - oldY
		self.vy = dY
		Object_PlatformMove(self, 0, dY) -- HERE

		DBGTEXT = tostring(self.y)
	end
}

function Obj_Platform(self, dt)
	if self.state == 'init' then
		self.state = 'main'
		Object_SetCollidable(self, 'top', 'dynamics', Coll_Flags.None, self.sprW, 36)
		self.colIsPlatform = true
		self.direction = self.properties.direction
		self.distance = tonumber(self.properties.distance) * TILE_SIZE
		self.phase = 0
		self.initialY = self.y
	end

	if self.state == 'main' then
		Update[self.direction](self, dt)
	end
end