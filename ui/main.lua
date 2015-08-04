local pixel = require "pixel"
local ui = require "ui"

local m = {}

local obj = pixel.sprite("warrior", "main")
obj.btn_menu.message = true
obj.btn_menu.menu.text = "Main Menu"


obj.score.text = "Score: "..game.score
obj.life.text = "#[red]"..game.life.."#[stop]"


ui:button("ui.main.btn_menu", function()
	ui:show("ui.loading")
end)

local ship = pixel.sprite("ship", "ship")
ship:ps(160, 400)
pixel.play(ship)

function m:show()
	if game.sound == 1 then
		audio.play("asset/wav/bgMusic_new.wav")
	end
end

function m:hide()

end

function m:draw()
	obj:draw()
	ship:draw()
end

function m:touch(what, x, y)

end

function m:update()

end

m.obj = obj
return m
