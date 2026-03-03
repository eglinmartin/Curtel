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


function RenderManager:drawText(text, x, y, stepY)
    stepY = stepY or 1

    local currentX = x
    local currentY = y

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

    -- love.graphics.setColor(75/255, 90/255, 87/255, 1)
    -- love.graphics.print("10/10", 98, 56)
    -- love.graphics.print("10/10", 97, 56)
    -- love.graphics.print("10/10", 96, 56)
    -- love.graphics.print("10/10", 98, 55)
    -- love.graphics.print("10/10", 98, 54)

    -- love.graphics.setColor(51/255, 39/255, 45/255, 1)
    -- love.graphics.print("10/10", 95, 53)
    -- love.graphics.print("10/10", 96, 53)
    -- love.graphics.print("10/10", 97, 53)
    -- love.graphics.print("10/10", 97, 54)
    -- love.graphics.print("10/10", 97, 55)
    -- love.graphics.print("10/10", 96, 55)
    -- love.graphics.print("10/10", 95, 55)
    -- love.graphics.print("10/10", 95, 54)

    love.graphics.setColor(184/255, 99/255, 67/255, 1)
    self:drawText("5/10", 22, 27, 0)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(170/255, 143/255, 104/255, 1)
    self:drawText("100", 22, 37, 0)
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
    if colour == 'green' then
        self.shadow_colour = {75/255, 90/255, 87/255, 1}
    elseif colour == 'red' then
        self.shadow_colour = {105/255, 67/255, 67/255, 1}
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

