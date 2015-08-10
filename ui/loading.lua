local pixel = require "pixel"
local math = require "math"

local m = {}

local obj = pixel.sprite("warrior", "loading")
obj.btn_new.message = true
obj.btn_option.message = true
obj.btn_about.message = true

ui:button("ui.loading.btn_new", function()
	audio.play("asset/wav/buttonEffet_new.wav")
	ui:show("ui.main")
end)

ui:button("ui.loading.btn_option", function()
	audio.play("asset/wav/buttonEffet_new.wav")
	ui:show("ui.option")
end)

ui:button("ui.loading.btn_about", function()
	audio.play("asset/wav/buttonEffet_new.wav")
	ui:show("ui.about")
end)

obj.ship = pixel.sprite("ship", "ship")

local pos = {}
local tar = {}
local move_cancel

local function move_end(obj)
	obj:ps(pos.x, pos.y)
	move_cancel = pixel.tween(obj, 20+20*math.random(), pos, tar, function(obj)
		if tar.y > 0 then
			pos.x = tar.x
			pos.y = tar.y
			tar.y = -100
			tar.x = math.random()*game.width
		else
			tar.x = math.random()*game.width
			tar.y = 200+math.random()*20
			pos.x = math.random()*game.width
			pos.y = game.height
		end
		move_end(obj)
	end, function(obj, p)
		obj:ps(p.x, p.y)
	end)
end

function m:show()
	pos.x = math.random()*game.width
	pos.y = game.height
	tar.x = math.random()*game.width
	tar.y = 200+math.random()*20
	move_end(obj.ship)
end

function m:hide()
	move_cancel()
end

function m:draw()
	obj:draw()
end

function m:update()

end

m.obj = obj
return m
