local Class = require("lib.class")

local TextObject = Class{}


function TextObject:init(name, text, colour, x, y, scale, rot, depth, align)
    self.name = name
    self.text = text
    self.colour = colour
    self.depth = depth
    self.align = align
    
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


function TextObject:update(dt)
    self.dx = self:return_to_xy(self.dx, dt)
    self.dy = self:return_to_xy(self.dy, dt)
    self.dscale = self:return_to_scale(dt)
end


function TextObject:return_to_xy(d, dt)
    local decay = 16
    d = d * math.exp(-decay * dt)

    if math.abs(d) < 0.1 then
        return 0
    end

    return d
end


function TextObject:return_to_scale(dt)
    local decay = 16

    if math.abs(self.dscale) < 0.001 then
        return 0
    end

    return self.dscale
end


return TextObject
