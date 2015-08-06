local pixel = require "pixel"

local bullet = {}
bullet.free_bullets = {}
bullet.bullets = {}
bullet.speed = 10

local bullet_meta = {}

function bullet:new()
    if #self.free_bullets > 0 then
        return table.remove(self.free_bullets)
    else
        local b = {}
        b.obj = pixel.sprite("res", "W1")
        return setmetatable(b, {__index=bullet_meta})
    end
end

function bullet:draw()
    for i, v in ipairs(bullet.bullets) do
        v.obj:draw()
    end
end

function bullet_meta:run(x, y)
    self.obj:ps(x, y)
    pixel.tween(self.obj, bullet.speed, {x=x,y=y}, {x=x, y=0}, function(obj)
        self:free()
    end, function(obj, p)
        obj:ps(p.x, p.y)
    end)
    table.insert(bullet.bullets, self)
end

function bullet_meta:free()
    for i, v in ipairs(bullet.bullets) do
		if v == self then
			table.remove(bullet.bullets, i)
			table.insert(bullet.free_bullets, v)
			break
		end
	end
end

return bullet
