local pixel = require "pixel"

local emery_bullet = {}
emery_bullet.free_emery_bullets = {}
emery_bullet.emery_bullets = {}
emery_bullet.speed = 20

local emery_bullet_meta = {}

function emery_bullet:new()
    if #self.free_emery_bullets > 0 then
        return table.remove(self.free_emery_bullets)
    else
        local b = {}
        b.obj = pixel.sprite("res", "W2")
        return setmetatable(b, {__index=emery_bullet_meta})
    end
end

function emery_bullet:stop()
    self.emery_bullets = {}
end

function emery_bullet:draw()
    for i, v in ipairs(emery_bullet.emery_bullets) do
        v.obj:draw()
    end
end

function emery_bullet_meta:run(x, y)
    self.obj:ps(x, y)
    pixel.tween(self.obj, emery_bullet.speed, {x=x,y=y}, {x=x, y=game.height}, function(obj)
        self:free()
    end, function(obj, p)
        obj:ps(p.x, p.y)
    end)
    table.insert(emery_bullet.emery_bullets, self)
end

function emery_bullet_meta:free()
    for i, v in ipairs(emery_bullet.emery_bullets) do
		if v == self then
			table.remove(emery_bullet.emery_bullets, i)
			table.insert(emery_bullet.free_emery_bullets, v)
			break
		end
	end
end

return emery_bullet
