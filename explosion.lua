local pixel = require "pixel"

local explosion = {}
explosion.free_explosions = {}
explosion.explosions = {}

local explosion_meta = {}

function explosion:new()
    if #self.free_explosions > 0 then
        return table.remove(self.free_explosions)
    else
        local o = {}
        o.obj = pixel.sprite("explosion", "explosion")
        return setmetatable(o, {__index=explosion_meta})
    end
end

function explosion:draw()
    for i, v in ipairs(explosion.explosions) do
        v.obj:draw()
    end
end

function explosion_meta:run(x, y)
    self.obj:ps(x, y)
    pixel.play(self.obj, nil, function(obj)
        self:free()
    end, 1)
    table.insert(explosion.explosions, self)
end

function explosion_meta:free()
    for i, v in ipairs(explosion.explosions) do
		if v == self then
			table.remove(explosion.explosions, i)
			table.insert(explosion.free_explosions, v)
			break
		end
	end
end

return explosion
