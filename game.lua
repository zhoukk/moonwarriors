package.path = package.path .. ";../pixel/pixel_c/lualib/?.lua"

pixel = require "pixel"
pack = require "spritepack"
shader = require "shader"
ui = require "ui"
audio = require "audio"

pack.load {
	pattern = [[asset/?]]
}
pixel.font "asset/pixel.ttf"
pixel.fps(30)
pixel.size(320, 480)

game = {}
game.center_x = 160
game.center_y = 240
game.sound = 1
game.mode = 1
game.score = 20
game.life = 4

math.randomseed(os.time())

ui:show("ui.loading")

if game.sound == 1 then
	audio.play("asset/wav/mainMainMusic_new.wav")
end

pixel.start {
	drawframe = function()
		pixel.clear(0xff808080)
		shader.blend(770, 771)
		ui:draw()
	end,
	update = function()
		ui:update()
	end,
	touch = function(what, x, y)
		if ui:touch(what, x, y) then
			return
		end
	end,
	key = function(what, ch)

	end,
	handle_error = function(...)
		pixel.err(...)
	end,
}
