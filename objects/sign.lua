local GX = love.graphics

local Sign_Font
local function Sign_DrawMessage(self)
	GX.setColor(0, 32, 64, 64)
	GX.rectangle('fill', self.x + 64 - 110, self.y - 106, 220, 96, 10)
	GX.setColor(255, 255, 255, 255)
	local f = GX.getFont()
	GX.setFont(Sign_Font)
	GX.printf(self.properties.message, self.x + 64 - 100, self.y - 96, 200, 'center')
	GX.setFont(f)
end

function Obj_Sign(self)
	if self.state == 'init' then
		self.state = 'main'
		self.colW, self.colH = TILE_SIZE, TILE_SIZE
		if Sign_Font == nil then
			Sign_Font = GX.newFont("fonts/grobold.ttf", 24)
		end
	end

	if self.state == 'main' then
		if RectsOverlap(self.x, self.y, self.colW, self.colH, Player.x, Player.y, Player.colW, Player.colH) then
			self.drawExtra = Sign_DrawMessage
		else
			self.drawExtra = nil
		end
	end
end
