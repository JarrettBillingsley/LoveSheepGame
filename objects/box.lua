function Obj_Box(self)
	if(self.state == 'init') then
		self.state = 'main'
		Object_SetCollidable(self, 'all', TILE_SIZE, TILE_SIZE)
	end
end
