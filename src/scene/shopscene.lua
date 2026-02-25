local Class = require("lib.class")

local ShopScene = Class{}


function ShopScene:init(GAME_STATE, RENDER_MANAGER, EVENT_MANAGER)
    self.game_state = GAME_STATE
    self.render_manager = RENDER_MANAGER
    self.event_manager = EVENT_MANAGER
end


function ShopScene:update(dt)
end


function ShopScene:draw()
    love.graphics.setColor(1, 1, 1, 1)
end


function ShopScene:enter()
    self:update_sprites()
    self.render_manager:set_shadow_colour("green")
    self.render_manager.draw_objects_background["background"].dscale = 0.1
    self.render_manager.draw_objects_foreground["barrel_base"].dy = 4
end


function ShopScene:update_sprites()
    self.render_manager:clear_sprites()
    self.render_manager:create_draw_object_background("background", "background_green", "game", 96, 54, 0, 1)
    self.render_manager:create_draw_object_foreground("barrel_base", "barrel", "base", 138, 54, 0, 1)
end


function ShopScene:setup_events()
end


function ShopScene:exit()
end


return ShopScene
