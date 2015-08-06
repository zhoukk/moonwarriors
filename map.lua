local pixel = require "pixel"
local shader = require "shader"
local pack = require "spritepack"
local texture = require "pixel.texture"


local map = {}

function map:init()
    self.tid = pack.texture("asset/res/bg.png")
    self.w, self.h = texture.size(self.tid)
    self.y = 0
end

function map:draw()
    local y = game.height-self.y
	local sy = (self.y-game.center_y)*16

	self.src = {0, 0, 0, y, game.width, y, game.width, 0}
	self.screen = {-8*game.width, sy, -8*game.width, 8*game.height, 8*game.width, 8*game.height, 8*game.width, sy}
	shader.draw(self.tid, self.src, self.screen)

	y = self.h-self.y
	self.src = {0, y, 0, self.h, game.width, self.h, game.width, y}
	self.screen = {-8*game.width, -8*game.height, -8*game.width, sy, 8*game.width, sy, 8*game.width, -8*game.height}
	shader.draw(self.tid, self.src, self.screen)
end

function map:update()
    self.y = self.y + 2
	if self.y >= self.h then
		self.y = 0
	end
end

return map
