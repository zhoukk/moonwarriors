local pixel = require "pixel"
local ui = require "ui"

local m = {}

local obj = pixel.sprite("warrior", "over")
obj.btn_playagain.message = true
obj.text_score.text = "You score is "..game.score

ui:button("ui.over.btn_playagain", function()
	ui:show("ui.loading")
end)

m.obj = obj
return m