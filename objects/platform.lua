local Speed = 0.01 * PER_FRAME

local Update =
{
	ud = function(self, dt)
		self.phase = self.phase + Speed * dt

		if self.phase >= 2 then
			self.phase = self.phase - 2
		end

		local oldY = self.y
		local newY = self.initialY + math.sin(self.phase * math.pi) * self.distance
		local dY = newY - oldY

		if self.beingStoodOn then
			if dY < 0 then
				Object_PlatformMove(self.standingObj, 0, dY)
				Coll_Translate(self, 0, dY)
			else
				Coll_Translate(self, 0, dY)
				Object_PlatformMove(self.standingObj, 0, dY)
			end
		else
			Coll_Translate(self, 0, dY)
		end
	end
}

function Obj_Platform(self, dt)
	if self.state == 'init' then
		self.state = 'main'
		Object_SetCollidable(self, 'top', self.sprW, 36)
		self.direction = self.properties.direction
		self.distance = tonumber(self.properties.distance) * TILE_SIZE
		self.phase = 0
		self.initialY = self.y
	end

	if self.state == 'main' then
		Update[self.direction](self, dt)
	end
end