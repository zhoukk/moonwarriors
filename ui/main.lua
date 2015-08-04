local pixel = require "pixel"
local ui = require "ui"

local m = {}

local obj = pixel.sprite("warrior", "main")
obj.btn_menu.message = true
obj.btn_menu.menu.text = "Main Menu"


obj.score.text = "Score: "..game.score
obj.life.text = "#[red]"..game.life.."#[stop]"

if game.sound == 1 then
	audio.play("asset/wav/bgMusic_new.wav")
end

ui:button("ui.main.btn_menu", function()
	ui:show("ui.loading")
end)

m.obj = obj
return m