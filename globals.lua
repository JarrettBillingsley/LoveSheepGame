-- Constants

TILE_SIZE = 128

PER_FRAME = 60
PER_FRAME_2 = PER_FRAME * PER_FRAME

Gravity = 1.0 * PER_FRAME_2

-- Variables

Player_Texture = 0
Enemy_Texture = 0
GameObjects = {}
NumGameObjects = 0
Player = 0
ObjectTypes = 0
Coll_Flags = 0

DBGTEXT = ''
DBGTABLE = {msg = ''}
DBG_Freeze = false
DBG_Step = false

function DBGPRINT(...)
	local args = {...}

	for i = 1, #args do
		DBGTEXT = DBGTEXT .. tostring(args[i])
	end

	DBGTEXT = DBGTEXT .. '\n'
end

setmetatable(_G, {
	__index = function(self, name)
		error("attempting to get nonexistent global '" .. name .. "'")
	end,

	__newindex = function(self, name, val)
		if type(val) ~= 'function' then
			error("attempting to set nonexistent global '" .. name .. "'")
		else
			rawset(self, name, val)
		end
	end,
})