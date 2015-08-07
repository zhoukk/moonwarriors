local pixel = require "pixel"
local player = require "player"
local emery_bullet = require "emery_bullet"

local emery = {}
emery.free_emerys = {}
emery.emerys = {}

local emery_meta = {}

function emery:new(name)
    if emery.free_emerys[name] and #emery.free_emerys[name] > 0 then
        return table.remove(emery.free_emerys[name])
    else
        local e = {}
        e.obj = pixel.sprite("res", name)
        e.name = name
        return setmetatable(e, {__index=emery_meta})
    end
end

function emery:draw()
    for i, v in ipairs(emery.emerys) do
        v.obj:draw()
    end
end

function emery:start()
    self._stop = false
    pixel.timeout(15, function()
        if self._stop then
            return "exit"
        end
        local i = math.random(1, 5)
        local e = self:new("E"..i)
        e:run(math.random(10, game.width-10), 0)
    end)
end

function emery:stop()
    self._stop = true
    self.emerys = {}
end

function emery_meta:run(x, y)
    self.x = x
    self.y = y
    self._shot_stop = false
    self.hp = 100
    self.obj:ps(self.x, self.y)
    if math.random(0, 100) > 70 then
        self:dive()
    else
        local tar = {x=math.random(10, game.width-10),y=math.random(game.center_y-100, game.center_y+30)}
        pixel.tween(self.obj, math.random(10, 20), {x=x,y=y}, tar, function(obj)
            self.x = tar.x
            self.y = tar.y
            obj:ps(self.x, self.y)
            self:around()
        end, function(obj, p)
            self.x = p.x
            self.y = p.y
            obj:ps(self.x, self.y)
        end)
        pixel.timeout(math.random(20, 30), function()
            if self._shot_stop then
                return "exit"
            end
            self:shot(20)
        end)
    end
    table.insert(emery.emerys, self)
end

function emery_meta:around()
    local tar = {x=math.random(10, game.width-10), y=self.y}
    pixel.tween(self.obj, 15, {x=self.x,y=self.y}, tar, function(obj)
        self.x = tar.x
        self.y = tar.y
        obj:ps(self.x, self.y)
        self:around()
    end, function(obj, p)
        self.x = p.x
        self.y = p.y
        obj:ps(self.x, self.y)
    end)
end

function emery_meta:shot()
    local eb = emery_bullet:new()
    eb:run(self.x, self.y)
end

function emery_meta:hurt()
    self.hp = self.hp-math.random(20, 25)
    return self.hp
end

function emery_meta:dive()
    local tar = {x=math.floor(game.height*(player.x-self.x)/player.y+self.x), y=game.height}
    pixel.tween(self.obj, math.random(25, 30), {x=self.x,y=self.y}, tar, function(obj)
        self:free()
    end, function(obj, p)
        self.x = p.x
        self.y = p.y
        obj:ps(self.x, self.y)
    end)
end

function emery_meta:free()
    self._shot_stop = true
    for i, v in ipairs(emery.emerys) do
        if v == self then
            table.remove(emery.emerys, i)
            if not emery.free_emerys[self.name] then
                emery.free_emerys[self.name] = {}
            end
            table.insert(emery.free_emerys[self.name], v)
            break
        end
    end
end

return emery
