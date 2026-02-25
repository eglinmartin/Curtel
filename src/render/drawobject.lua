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

    self.dx = self:return_to_xy(self.dx, dt)
    self.dy = self:return_to_xy(self.dy, dt)
    self.dscale = self:return_to_scale(dt)
end


function DrawObject:return_to_xy(d, dt)
    local decay = 16
    d = d * math.exp(-decay * dt)

    if math.abs(d) < 0.1 then
        return 0
    end

    return d
end


function DrawObject:return_to_scale(dt)
    local decay = 16
    self.dscale = self.dscale * math.exp(-decay * dt)

    if math.abs(self.dscale) < 0.001 then
        return 0
    end

    return self.dscale
end


return DrawObject
