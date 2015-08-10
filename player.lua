local pixel = require "pixel"
local bullet = require "bullet"

local player = {}

local function shot_side(off)
	local b = bullet:new()
	b:run(player.x+off, player.y-13)
end

function player:init(x, y)
	self.obj = pixel.sprite("ship", "ship")
	self.obj:ps(x, y)
	self.x = x
	self.y = y
	self._shot_speed = 3
	self._shot_stop = false
	self.hp = 5
end

function player:shot()
	pixel.play(self.obj)
	self._shot_stop = pixel.timeout(self._shot_speed, function()
		shot_side(13)
		shot_side(-13)
	end)
end

function player:hurt()
	self.hp = self.hp - 1
	return self.hp
end

function player:stop_shot()
	self._shot_stop()
end

local old_x = 0
local old_y = 0
function player:touch(what, x, y)
	if what == "BEGIN" then
		old_x = x
		old_y = y
	elseif what == "MOVE" then
		local dx = x-old_x + self.x
		local dy = y-old_y + self.y
		if dx > 0 and dx < game.width then
			self.x = dx
		end
		if dy > 0 and dy < game.height then
			self.y = dy
		end
		self.obj:ps(self.x, self.y)
		old_x = x
		old_y = y
	end
end

function player:draw()
	self.obj:draw()
end

return player
