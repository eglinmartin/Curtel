local Class = require("lib.class")

local GameScene = Class{}


function GameScene:init(GAME_STATE, RENDER_MANAGER, EVENT_MANAGER)
    self.game_state = GAME_STATE
    self.render_manager = RENDER_MANAGER
    self.event_manager = EVENT_MANAGER

    self.player = self.game_state.player
end


function GameScene:update(dt)
    if self.player then
        self.player:update(dt)
    end
end


function GameScene:draw()
    love.graphics.setColor(1, 1, 1, 1)

    if self.player then
        self.player:draw()
    end
end


function GameScene:enter()
    self:update_sprites()
    self.render_manager:set_shadow_colour("green")
    self.render_manager.draw_objects_background["background"].dscale = 0.1
    self.render_manager.draw_objects_foreground["player"].dy = 4
    self.render_manager.draw_objects_foreground["hud_player_health"].dy = 4
    self.render_manager.draw_objects_foreground["hud_player_money"].dy = 4
end


function GameScene:update_sprites()
    self.render_manager:clear_sprites()
    self.render_manager:create_draw_object_background("background", "background_green", "game", 96, 54, 0, 1)
    self.render_manager:create_draw_object_foreground("player", "player", "idle", self.player.x, self.player.y, 0, 1)
    self.render_manager:create_draw_object_foreground("hud_player_health", "icons", "heart", 15.5, 35.5, 0, 1)
    self.render_manager:create_draw_object_foreground("hud_player_money", "icons", "money", 15.5, 45.5, 0, 1)
end


function GameScene:setup_events()
end


function GameScene:exit()
end


return GameScene
