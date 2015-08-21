package.path = package.path .. ";../pixel/pixel_c/lualib/?.lua;../pixel/pixel_c/util/?.lua"

pixel = require "pixel"
pack = require "spritepack"
shader = require "shader"
ui = require "ui"
audio = require "pixel.audio"
local move = require "move"
local time = require "time"
local animation = require "animation"


pack.load {
	pattern = [[asset/?]]
}
pixel.font "asset/pixel.ttf"
pixel.fps(30)

local w, h = 320, 480

pixel.size(w, h)

game = {}
game.center_x = w/2
game.center_y = h/2
game.width = w
game.height = h
game.sound = 1
game.mode = 1

math.randomseed(os.time())

mainMainMusic_new = 1
audio.load(mainMainMusic_new, "asset/wav/mainMainMusic_new.wav")

buttonEffet_new = 2
audio.load(buttonEffet_new, "asset/wav/buttonEffet_new.wav")

ui:show("ui.loading")

pixel.start {
	drawframe = function()
		pixel.clear(0xff808080)
		shader.blend(BLEND_SRC_ALPHA, BLEND_ONE_MINUS_SRC_ALPHA)
		ui:draw()
	end,
	update = function()
		ui:update()
		move()
		time()
		animation()
	end,
	touch = function(what, x, y)
		if ui:touch(what, x, y) then
			return
		end
	end,
	key = function(what, ch)

	end,
	handle_error = function(...)
		pixel.log(...)
	end,
}
