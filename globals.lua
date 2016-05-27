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