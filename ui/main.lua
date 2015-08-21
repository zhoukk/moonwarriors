local pixel = require "pixel"
local shader = require "shader"
local pack = require "spritepack"
local texture = require "pixel.texture"
local ui = require "ui"
local map = require "map"
local player = require "player"
local bullet = require "bullet"
local emery = require "emery"
local emery_bullet = require "emery_bullet"
local explosion = require "explosion"

local m = {}

local obj = pixel.sprite("warrior", "main")
obj.btn_menu.message = true
obj.btn_menu.menu.text = "Main Menu"

ui:button("ui.main.btn_menu", function()
	ui:show("ui.loading")
end)

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

local bgmusic

function m:show()
	if game.sound == 1 then
		bgmusic = audio.play(bgMusic_new, true)
	end
	game.score = 0
	game.life = 4
	obj.life.text = "#[red]"..game.life.."#[stop]"
	obj.score.text = "Score: "..game.score

	map:init()
	player:init(game.center_x, game.height-60)
	player:shot()
	emery:start()
end

function m:hide()
	player:stop_shot()
	emery:stop()
	emery_bullet:stop()
	audio.stop(bgmusic)
end

function m:draw()
	map:draw()

	shader.blend(BLEND_SRC_ALPHA, BLEND_ONE)
	bullet:draw()
	emery_bullet:draw()
	explosion:draw()
	shader.blend(BLEND_SRC_ALPHA, BLEND_ONE_MINUS_SRC_ALPHA)

	emery:draw()
	player:draw()
	obj:draw()
end

function m:touch(what, x, y)
	player:touch(what, x, y)
end

local function player_die()
	game.life = game.life - 1
	if game.life == 0 then
		ui:show("ui.over")
	end
	obj.life.text = "#[red]"..game.life.."#[stop]"
end

function m:update()
	map:update()

	for i, v in ipairs(emery.emerys) do
		for j, k in ipairs(bullet.bullets) do
			if collide(v.obj, k.obj) then
				k:free()
				if v:hurt() <= 0 then
					local x1,y1,x2,y2 = v.obj:aabb()
					local e = explosion:new()
					e:run((x2+x1)/2, (y2+y1)/2)
					v:free()
					audio.play(explodeEffect_new)
					game.score = game.score + 10
					obj.score.text = "Score: "..game.score
				end
			end
		end
		if collide(v.obj, player.obj) then
			v:free()
			audio.play(shipDestroyEffect_new)
			player_die()
			break
		end
	end

	for i, v in ipairs(emery_bullet.emery_bullets) do
		if collide(v.obj, player.obj) then
			v:free()
			if player:hurt() <= 0 then
				audio.play(shipDestroyEffect_new)
				player_die()
				break
			end
		end
	end
end

m.obj = obj
return m
