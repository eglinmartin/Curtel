local Class = require("lib.class")
local peachy = require("lib.peachy")

local DrawObject = require("src.render.drawobject")
local RenderManager = Class{}


local shadowShader = love.graphics.newShader([[
    vec4 effect(vec4 color, Image tex, vec2 texCoords, vec2 screenCoords) {
        vec4 pixel = Texel(tex, texCoords);
        if (pixel.a == 0.0) {
            // Keep transparent pixels untouched
            return vec4(0.0, 0.0, 0.0, 0.0);
        }
        // Overwrite non-transparent pixels with outline color
        return vec4(color.rgb, pixel.a);
    }
]])


local Colours = {
    RED1 = {184/255, 99/255, 67/255, 1},
    RED2 = {147/255, 78/255, 72/255, 1},
    RED3 = {105/255, 67/255, 67/255, 1},
    RED4 = {81/255, 62/255, 69/255, 1},
    ORANGE1 = {198/255, 164/255, 130/255, 1},
    ORANGE2 = {188/255, 133/255, 99/255, 1},
    YELLOW1 = {170/255, 143/255, 104/255, 1},
    YELLOW2 = {141/255, 121/255, 78/255, 1},
    YELLOW3 = {97/255, 92/255, 80/255, 1},
    GREEN1 = {175/255, 179/255, 129/255, 1},
    GREEN2 = {138/255, 153/255, 109/255, 1},
    GREEN3 = {102/255, 132/255, 95/255, 1},
    GREEN4 = {81/255, 108/255, 94/255, 1},
    GREEN5 = {75/255, 90/255, 87/255, 1},
    BROWN1 = {171/255, 155/255, 142/255, 1},
    BROWN2 = {132/255, 120/255, 117/255, 1},
    BROWN3 = {108/255, 89/255, 92/255, 1},
    GREY1 = {154/255, 155/255, 167/255, 1},
    GREY2 = {136/255, 131/255, 152/255, 1},
    GREY3 = {113/255, 98/255, 125/255, 1},
    GREY4 = {91/255, 69/255, 95/255, 1},
    GREY5 = {73/255, 52/255, 61/255, 1},
    WHITE = {210/255, 201/255, 165/255, 1},
    BLACK = {40/255, 31/255, 35/255, 1},
}


function RenderManager:init(SCENE_MANAGER)
    self.scene_manager = SCENE_MANAGER
    self.colours = Colours

    self.font = love.graphics.newFont("assets/curtel.ttf", 16)
    love.graphics.setFont(self.font)

    self.shadow_colour = {75/255, 90/255, 87/255, 1}
    self.draw_objects_background = {}
    self.draw_objects_foreground = {}
end


function RenderManager:clear_sprites()
    self.draw_objects_background = {}
    self.draw_objects_foreground = {}
end


function RenderManager:update(dt)
    -- Update background animations
    for _, draw_object in pairs(self.draw_objects_background) do
       draw_object:update(dt)
    end

    -- Update foreground animations
    for _, draw_object in pairs(self.draw_objects_foreground) do
       draw_object:update(dt)
    end
end


function RenderManager:drawText(text, x, y, stepY, align)
    stepY = stepY or 0

    local currentX = x
    local currentY = y - 6

    if align=='centre' then
        local totalWidth = self.font:getWidth(text)
        currentX = x - totalWidth / 2
    end

    for i = 1, #text do
        local char = text:sub(i, i)

        love.graphics.print(char, currentX, currentY)

        currentX = currentX + self.font:getWidth(char)
        currentY = currentY + stepY
    end
end


function RenderManager:draw(rs)
    rs.push()

    -- Draw current scene to background canvas
    self:draw_background()

    -- Draw current scene to foreground canvas
    self:draw_foreground()
    love.graphics.setFont(self.font)

    love.graphics.setColor(self.colours.RED1)
    self:drawText("5/10", 22, 33, 0, "left")
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(self.colours.YELLOW1)
    self:drawText("100", 22, 43, 0, "left")
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(self.colours.GREY1)
    self:drawText("CURTEL", 96, 8, 0, "centre")
    love.graphics.setColor(1, 1, 1, 1)

    rs.pop()
end


function RenderManager:create_draw_object_background(sprite_id, sprite_name, sprite_tag, x, y, scale, rot, depth)
    self.draw_objects_background[sprite_id] =
        DrawObject(
            sprite_id,
            peachy.new(
                "bin/json/" .. sprite_name .. ".json",
                love.graphics.newImage("bin/backgrounds/" .. sprite_name .. ".png"),
                sprite_tag
            ),
            x, y, rot, scale, depth
        )
end


function RenderManager:create_draw_object_foreground(sprite_id, sprite_name, sprite_tag, x, y, scale, rot, depth)
    self.draw_objects_foreground[sprite_id] =
        DrawObject(
            sprite_id,
            peachy.new(
                "bin/json/" .. sprite_name .. ".json",
                love.graphics.newImage("bin/sprites/" .. sprite_name .. ".png"),
                sprite_tag
            ),
            x, y, rot, scale, depth
        )
end


function RenderManager:draw_background()
    -- Draw background layer
    for _, draw_obj in pairs(self.draw_objects_background) do
        draw_obj.sprite:draw(
            draw_obj.x + draw_obj.dx,
            draw_obj.y + draw_obj.dy,
            draw_obj.rot + draw_obj.drot,
            draw_obj.scale + draw_obj.dscale,
            draw_obj.scale + draw_obj.dscale,
            draw_obj.sprite:getWidth() / 2,
            draw_obj.sprite:getHeight() / 2
        )
    end
end


function RenderManager:draw_foreground()
    -- Sort sprites by depth
    local draw_list = {}
    for _, obj in pairs(self.draw_objects_foreground) do
        table.insert(draw_list, obj)
    end

    -- Sort by depth
    table.sort(draw_list, function(a, b)
        return a.depth < b.depth
    end)
    
    -- Draw shadows layer
    for _, draw_obj in ipairs(draw_list) do
        self:draw_shadow(
            draw_obj.sprite,
            draw_obj.x + draw_obj.dx,
            draw_obj.y + draw_obj.dy,
            draw_obj.rot + draw_obj.drot,
            draw_obj.scale + draw_obj.dscale,
            draw_obj.sprite:getWidth() / 2,
            draw_obj.sprite:getHeight() / 2
        )
    end

    -- Draw foreground layer
    for _, draw_obj in ipairs(draw_list) do
        draw_obj.sprite:draw(
            draw_obj.x + draw_obj.dx,
            draw_obj.y + draw_obj.dy,
            draw_obj.rot + draw_obj.drot,
            draw_obj.scale + draw_obj.dscale,
            draw_obj.scale + draw_obj.dscale,
            draw_obj.sprite:getWidth() / 2,
            draw_obj.sprite:getHeight() / 2
        )
    end
end


function RenderManager:set_shadow_colour(colour)
    self.shadow_colour = colour
end


function RenderManager:draw_shadow(anim, x, y, rot, scale, ox, oy)
    local outlineColor = self.shadow_colour

    love.graphics.setShader(shadowShader)
    love.graphics.setColor(outlineColor)

    anim:draw(x + 1, y + 1, rot, scale, scale, ox, oy)

    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 1)
end


return RenderManager

