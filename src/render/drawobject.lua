local Class = require("lib.class")

local DrawObject = Class{}


function DrawObject:init(name, sprite, x, y, scale, rot)
    self.name = name
    self.sprite = sprite
    
    -- Bring in object's real location parameters
    self.x = x
    self.y = y
    self.scale = scale
    self.rot = rot

    -- Create theoretical location parameters
    self.dx = 0
    self.dy = 0
    self.dscale = 0
    self.drot = 0
end


function DrawObject:update(dt)
    self.sprite:update(dt)

    self.dx = self:return_to_xy(self.dx, dt, 0)
    self.dy = self:return_to_xy(self.dy, dt, 0)
    self.dscale = self:return_to_xy(self.dscale, dt, 0)
end


function DrawObject:return_to_xy(d, dt, default)
    local decay = 16
    d = d * math.exp(-decay * dt)

    if math.abs(d) < 0.1 then
        return default
    end

    return d
end


return DrawObject
