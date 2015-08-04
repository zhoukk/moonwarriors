local pixel = require "pixel"

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

m.obj = obj
return m