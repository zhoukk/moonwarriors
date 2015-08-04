local pixel = require "pixel"
local ui = require "ui"

local enum_sound = {
	"On",
	"Off",
}

local enum_mode = {
	"Easy",
	"Normal",
	"Hard",
}

local m = {}

local obj = pixel.sprite("warrior", "option")
obj.btn_sound.message = true
obj.btn_mode.message = true
obj.btn_back.message = true
obj.btn_back.text_back.text = "Go Back"
obj.sound.text = "Sound"
obj.mode.text = "Mode"

obj.btn_sound.text_sound.text = enum_sound[game.sound]
obj.btn_mode.text_mode.text = enum_mode[game.mode]

ui:button("ui.option.btn_sound", function()
	if game.sound == 1 then
		game.sound = 2
	else
		game.sound = 1
	end
	obj.btn_sound.text_sound.text = enum_sound[game.sound]
end)

ui:button("ui.option.btn_mode", function()
	game.mode = game.mode + 1
	if game.mode > 3 then
		game.mode = 1
	end
	obj.btn_mode.text_mode.text = enum_mode[game.mode]
end)

ui:button("ui.option.btn_back", function()
	audio.play("asset/wav/buttonEffet_new.wav")
	ui:show("ui.loading")
end)

m.obj = obj
return m