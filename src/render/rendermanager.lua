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


function RenderManager:init(SCENE_MANAGER)
    self.scene_manager = SCENE_MANAGER

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


function RenderManager:draw(rs)
    rs.push()

    -- Draw current scene to background canvas
    self:draw_background()

    -- Draw current scene to foreground canvas
    self:draw_foreground()

    rs.pop()
end


function RenderManager:create_draw_object_background(sprite_id, sprite_name, sprite_tag, x, y, scale, rot)
    table.insert(
        self.draw_objects_background,
        DrawObject(sprite_id, peachy.new("bin/json/" ..sprite_name.. ".json", love.graphics.newImage("bin/backgrounds/" ..sprite_name.. ".png"), sprite_tag),
        x, y, rot, scale)
    )
end


function RenderManager:create_draw_object_foreground(sprite_id, sprite_name, sprite_tag, x, y, scale, rot)
    self.draw_objects_foreground[sprite_id] =
        DrawObject(
            sprite_id,
            peachy.new(
                "bin/json/" .. sprite_name .. ".json",
                love.graphics.newImage("bin/sprites/" .. sprite_name .. ".png"),
                sprite_tag
            ),
            x, y, rot, scale
        )
end


function RenderManager:draw_background()
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
    for _, draw_obj in pairs(self.draw_objects_foreground) do
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

    for _, draw_obj in pairs(self.draw_objects_foreground) do
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
    if colour == 'green' then
        self.shadow_colour = {75/255, 90/255, 87/255, 1}
    elseif colour == 'red' then
        self.shadow_colour = {81/255, 62/255, 69/255, 1}
    end
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

