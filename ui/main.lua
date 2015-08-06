local pixel = require "pixel"
local shader = require "shader"
local pack = require "spritepack"
local texture = require "pixel.texture"
local ui = require "ui"

local m = {}

local obj = pixel.sprite("warrior", "main")
obj.btn_menu.message = true
obj.btn_menu.menu.text = "Main Menu"
obj.life.text = "#[red]"..game.life.."#[stop]"
obj.score.text = "Score: "..game.score

local bgtid = pack.texture("asset/res/bg.png")
local bg_w, bg_h = texture.size(bgtid)
local bg_y = 0
local ship_x = game.center_x
local ship_y = 420
local bullet_speed = 10
local shot_speed = 3
local bullets = {}
local freebullets = {}
local freeemerys = {}
local emerys = {}
local freeemerybullets = {}
local emerybullets = {}
local freeexplosions = {}
local explosions = {}

local function get_emery(name)
	if #freeemerys > 0 then
		return table.remove(freeemerys)
	else
		return pixel.sprite("res", name)
	end
end

local function free_emery(obj)	
	for i, v in ipairs(emerys) do
		if v == obj then
			table.remove(emerys, i)
			table.insert(freeemerys, obj)
			break
		end
	end
end

local function get_bullet()
	if #freebullets > 0 then
		return table.remove(freebullets)
	else
		return pixel.sprite("res", "W1")
	end
end

local function free_bullet(obj)
	for i, v in ipairs(bullets) do
		if v == obj then
			table.remove(bullets, i)
			table.insert(freebullets, obj)
			break
		end
	end
end

local function get_emerybullet()
	if #freeemerybullets > 0 then
		return table.remove(freeemerybullets)
	else
		return pixel.sprite("res", "W2")
	end
end

local function free_emerybullet(obj)
	for i, v in ipairs(emerybullets) do
		if v == obj then
			table.remove(emerybullets, i)
			table.insert(freeemerybullets, obj)
			break
		end
	end
end

local function get_explosion()
	if #freeexplosions > 0 then
		return table.remove(freeexplosions)
	else
		return pixel.sprite("explosion", "explosion")
	end
end

local function free_explosion(obj)
	for i, v in ipairs(explosions) do
		if v == obj then
			table.remove(explosions, i)
			table.insert(freeexplosions, obj)
			break
		end
	end
end

ui:button("ui.main.btn_menu", function()
	ui:show("ui.loading")
end)

local ship = pixel.sprite("ship", "ship")
ship:ps(ship_x, ship_y)
pixel.play(ship)

local function shot(off)
	local bullet = get_bullet()
	local src = {x=ship_x+off, y=ship_y-13}
	bullet:ps(src.x, src.y)
	pixel.tween(bullet, bullet_speed, src, {x=src.x, y=0}, function(obj)
		free_bullet(obj)
	end, function(obj, p)
		obj:ps(p.x, p.y)
	end)
	table.insert(bullets, bullet)
end

local function emery_shot(x, y, s)
	local emerybullet = get_emerybullet()
	emerybullet:ps(x, y)
	pixel.tween(emerybullet, s, {x=x,y=y},{x=x,y=game.height}, function(obj)
		free_emerybullet(obj)
	end, function(obj, p)
		obj:ps(p.x, p.y)
	end)
	table.insert(emerybullets, emerybullet)
end

local function move_around(emery, pos)
	local tar = {x=math.random(10, game.width-10), y=pos.y}
	pixel.tween(emery, 15, pos, tar, function(obj)
		move_around(obj, pos)
	end, function(obj, p)
		pos.x = p.x
		pos.y = p.y
		obj:ps(p.x, p.y)
	end)
end

local function dive(emery, pos)
	local tar = {x=math.floor(game.height*(ship_x-pos.x)/ship_y+pos.x), y=game.height}
	pixel.tween(emery, math.random(15, 20), pos, tar, function(obj)
		free_emery(obj)
	end, function(obj, p)
		obj:ps(p.x, p.y)
	end)
end

local function collide(obj1, obj2)
	local o1x1,o1y1,o1x2,o1y2 = obj1:aabb()
	local o2x1,o2y1,o2x2,o2y2 = obj2:aabb()

	local zx = math.abs(o1x1+o1x2-o2x1-o2x2)
	local x = math.abs(o1x1-o1x2)+math.abs(o2x1-o2x2)
	local zy = math.abs(o1y1+o1y2-o2y1-o2y2)
	local y = math.abs(o1y1-o1y2)+math.abs(o2y1-o2y2)

	if zx <= x and zy <= y then
		return true
	else
		return false
	end
end

local shot_timeid
local emery_timeid

function m:show()
	if game.sound == 1 then
		audio.play("asset/wav/bgMusic_new.wav")
	end
	shot_timeid = pixel.timeout(shot_speed, function()
		shot(13)
		shot(-13)
	end)

	emery_timeid = pixel.timeout(15, function()
		local i = math.random(1, 5)
		local emery = get_emery("E"..i)
		local pos = {x=math.random(10, game.width-10), y=0}
		emery:ps(pos.x, pos.y)
		if math.random(0, 100) > 60 then
			dive(emery, pos)
		else
			local tar = {x=math.random(10, game.width-10),y=math.random(game.center_y-100, game.center_y+30)}
			pixel.tween(emery, math.random(10, 20), pos, tar, function(obj)
				move_around(obj, tar)
			end, function(obj, p)
				pos.x = p.x
				pos.y = p.y
				obj:ps(p.x, p.y)
			end)
			pixel.timeout(math.random(20, 30), function()
				emery_shot(pos.x, pos.y, 20)
			end)
		end
		table.insert(emerys, emery)
	end)
end

function m:hide()
	pixel.remove_time(shot_timeid)
end

function m:draw()
	local y = game.height-bg_y
	local sy = (bg_y-game.center_y)*16
	local bgsrc = {}
	local bgscreen = {}


	bgsrc = {0, 0, 0, y, game.width, y, game.width, 0}
	bgscreen = {-8*game.width, sy, -8*game.width, 8*game.height, 8*game.width, 8*game.height, 8*game.width, sy}
	shader.draw(bgtid, bgsrc, bgscreen)

	y = bg_h-bg_y
	bgsrc = {0, y, 0, bg_h, game.width, bg_h, game.width, y}
	bgscreen = {-8*game.width, -8*game.height, -8*game.width, sy, 8*game.width, sy, 8*game.width, -8*game.height}
	shader.draw(bgtid, bgsrc, bgscreen)

	shader.blend(BLEND_SRC_ALPHA, BLEND_ONE)
	for i, v in ipairs(bullets) do
		v:draw()
	end
	for i, v in ipairs(emerybullets) do
		v:draw()
	end
	for i, v in ipairs(emerys) do
		v:draw()
	end
	for i, v in ipairs(explosions) do
		v:draw()
	end
	ship:draw()
	shader.blend(BLEND_SRC_ALPHA, BLEND_ONE_MINUS_SRC_ALPHA)

	obj:draw()
end

local old_x = 0
local old_y = 0
function m:touch(what, x, y)
	if what == "BEGIN" then
		old_x = x
		old_y = y
	elseif what == "MOVE" then
		local dx = x-old_x + ship_x
		local dy = y-old_y + ship_y
		if dx > 0 and dx < game.width then
			ship_x = dx
		end
		if dy > 0 and dy < game.height then
			ship_y = dy
		end
		ship:ps(ship_x, ship_y)
		old_x = x
		old_y = y
	end
end

function m:update()
	bg_y = bg_y + 2
	if bg_y >= bg_h then
		bg_y = 0
	end

	for i, v in ipairs(bullets) do
		for j, k in ipairs(emerys) do
			if collide(v, k) then
				local explosion = get_explosion()
				local x1,y1,x2,y2 = k:aabb()
				explosion:ps((x2+x1)/2, (y2+y1)/2)
				pixel.play(explosion, nil, function(obj)
					free_explosion(obj)
				end, 1)
				table.insert(explosions, explosion)
				free_bullet(v)
				free_emery(k)
				game.score = game.score + 10
				obj.score.text = "Score: "..game.score
			end
		end
	end

end

m.obj = obj
return m
