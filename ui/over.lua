local pixel = require "pixel"
local ui = require "ui"

local m = {}

local obj = pixel.sprite("warrior", "over")
obj.btn_playagain.message = true

ui:button("ui.over.btn_playagain", function()
	ui:show("ui.loading")
end)

function m:show()
	obj.text_score.text = "You score is "..game.score
end

function m:hide()

end

function m:draw()
	obj:draw()
end

function m:update()

end

m.obj = obj
return m
