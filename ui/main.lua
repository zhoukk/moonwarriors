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
obj.life.text = "#[red]"..game.life.."#[stop]"
obj.score.text = "Score: "..game.score


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

function m:show()
	if game.sound == 1 then
		audio.play("asset/wav/bgMusic_new.wav")
	end

	map:init()
	player:init(game.center_x, game.height-60)
	player:shot()
	emery:start()
end

function m:hide()
	player:stop_shot()
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

function m:update()
	map:update()

	for i, v in ipairs(bullet.bullets) do
		for j, k in ipairs(emery.emerys) do
			if collide(v.obj, k.obj) then
				if k:hurt() <= 0 then
					local x1,y1,x2,y2 = k.obj:aabb()
					local e = explosion:new()
					e:run((x2+x1)/2, (y2+y1)/2)
					v:free()
					k:free()
					game.score = game.score + 10
					obj.score.text = "Score: "..game.score
				end
			end
		end
	end

end

m.obj = obj
return m
