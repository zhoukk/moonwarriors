local pixel = require "pixel"
local shader = require "shader"
local pack = require "spritepack"
local texture = require "pixel.texture"
local ui = require "ui"

local m = {}

local obj = pixel.sprite("warrior", "main")
obj.btn_menu.message = true
obj.btn_menu.menu.text = "Main Menu"


obj.score.text = "Score: "..game.score
obj.life.text = "#[red]"..game.life.."#[stop]"

local bgtid = pack.texture("asset/res/bg.png")
local bg_w, bg_h = texture.size(bgtid)
local bg_y = 0
local ship_x = game.center_x
local ship_y = 420
local bullet_speed = 10
local shot_speed = 3
local bullets = {}
local freebullets = {}

local function get_bullet()
	if #freebullets > 0 then
		return table.remove(freebullets)
	else
		return pixel.sprite("res", "W1")
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
		table.insert(freebullets, obj)
		for i, v in ipairs(bullets) do
			if v == obj then
				table.remove(bullets, i)
				break
			end
		end
	end, function(obj, p)
		obj:ps(p.x, p.y)
	end)
	table.insert(bullets, bullet)
end

local shot_timeid

function m:show()
	if game.sound == 1 then
		audio.play("asset/wav/bgMusic_new.wav")
	end
	shot_timeid = pixel.timeout(shot_speed, function()
		shot(13)
		shot(-13)
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
	shader.blend(BLEND_SRC_ALPHA, BLEND_ONE_MINUS_SRC_ALPHA)
	ship:draw()
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
end

m.obj = obj
return m
