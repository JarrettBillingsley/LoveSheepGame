local sti = require 'ext.sti'

local _map, _world
local drawCollision = false

local function _fromMapObj(mapObj, objType)
	local o = Object_New(objType)
	o.x, o.y = mapObj.x, mapObj.y - TILE_SIZE
	local tile = _map.tiles[mapObj.gid] or _map:setFlippedGID(mapObj.gid)
	o.img = _map.tilesets[tile.tileset].image
	o.frame = tile.quad
	return o
end

local function _loadObjects()
	local objects = _map.layers.objects
	objects.visible = false

	for _, obj in ipairs(objects.objects) do
		if obj.type == 'Obj_Player' then
			Player.x, Player.y = obj.x, obj.y
		else
			local o = _fromMapObj(obj, obj.type)
			o.properties = obj.properties
		end
	end

	_map:addCustomLayer('sprites', 3)
	local sprites = _map.layers.sprites

	function sprites:update(dt)
		Object_UpdateAll(dt)
	end

	function sprites:draw()
		Object_DrawAll()
	end
end

function Level_Load(filename)
	_map = sti.new(filename, { "mybump" })
	Coll_Init(_map)
	_loadObjects()
	Camera_Init(_map.backgroundcolor, _map.width * _map.tilewidth, _map.height * _map.tileheight)
end

function Level_Update(dt)
	_map:update(dt)
end

function Level_Draw(x, y, w, h)
	_map:setDrawRange(x, y, w, h)
	_map:draw()

	if drawCollision then
		Coll_Debug_DrawRects()
	end
end

function Level_Debug_ToggleDrawCollision()
	drawCollision = not drawCollision
end