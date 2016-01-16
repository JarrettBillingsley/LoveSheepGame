local function _hit(self, type, col)
	if type == 'slam' then
		self.state = 'slammed'
	end
end

function Obj_Box(self)
	if self.state == 'init' then
		self.state = 'main'
		self.hit = _hit
		Object_SetCollidable(self, 'all', TILE_SIZE, TILE_SIZE)
	end

	if self.state == 'slammed' then
		Object_Delete(self)
		return
	end
end
