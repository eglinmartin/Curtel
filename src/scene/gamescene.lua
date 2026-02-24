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

    love.graphics.setColor(75/255, 90/255, 87/255, 1)
    love.graphics.rectangle("fill", 0, 0, 192, 108)

    love.graphics.setColor(81/255, 108/255, 94/255, 1)
    love.graphics.rectangle("fill", 5, 5, 182, 98)
    
    if self.player then
        self.player:draw()
    end
end


function GameScene:enter()
    self:update_sprites()
    self:setup_events()
end


function GameScene:update_sprites()
    self.render_manager:create_draw_object_background("background", "game", 96, 54, 0, 1)
    self.render_manager:create_draw_object_foreground("player", "idle", self.player.x, self.player.y, 0, 1)
end


function GameScene:setup_events()
    self.event_manager:on(self.event_manager.events.NODPLAYER, function()
        self.render_manager.draw_objects_foreground["player"].dy = 4
    end)
end


function GameScene:exit()
end


return GameScene
