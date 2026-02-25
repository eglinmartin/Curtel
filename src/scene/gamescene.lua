local Class = require("lib.class")

local GameScene = Class{}


function GameScene:init(GAME_STATE, RENDER_MANAGER, EVENT_MANAGER)
    self.game_state = GAME_STATE
    self.render_manager = RENDER_MANAGER
    self.event_manager = EVENT_MANAGER

    self.player = self.game_state.player
    self.player_deck = self.game_state.player_deck
    self.player.hand = {self.player_deck.deck[1], self.player_deck.deck[2], self.player_deck.deck[3]}
end


function GameScene:update(dt)
    if self.player then
        self.player:update(dt)
    end

    self:setup_events()
end


function GameScene:draw()
    love.graphics.setColor(1, 1, 1, 1)

    if self.player then
        self.player:draw()
    end
end


function GameScene:enter()
    self:setup_events()

    self:update_sprites()
    self.render_manager:set_shadow_colour("green")
    self.render_manager.draw_objects_background["background"].dscale = 0.1
    self.render_manager.draw_objects_foreground["player"].dy = 4
    self.render_manager.draw_objects_foreground["hud_player_health"].dy = 4
    self.render_manager.draw_objects_foreground["hud_player_money"].dy = 4
    self.render_manager.draw_objects_foreground["hud_player_money"].dy = 4
    
    self.render_manager.draw_objects_foreground["player_card_1"].dy = 4
    self.render_manager.draw_objects_foreground["player_card_2"].dy = 4
    self.render_manager.draw_objects_foreground["player_card_3"].dy = 4
end


function GameScene:update_sprites()
    self.render_manager:clear_sprites()
    self.render_manager:create_draw_object_background("background", "background_green", "game", 96, 54, 0, 1)
    self.render_manager:create_draw_object_foreground("player", "player", "idle", self.player.x, self.player.y, 0, 1)

    self.render_manager:create_draw_object_foreground("hud_player_health", "icons", "heart", 15.5, 35.5, 0, 1)
    self.render_manager:create_draw_object_foreground("hud_player_money", "icons", "money", 15.5, 45.5, 0, 1)

    if #self.player.hand > 0 then
        for i, card in ipairs(self.player.hand) do
            self.render_manager:create_draw_object_foreground("player_card_" .. i, "cards_" .. card.suit, card.value, 8.5 + (9 * i), 77.5 + (3 * i), 0, 1)
        end
    end
end


function GameScene:setup_events()
    self.event_manager:on(
        self.event_manager.events.DEALCARDS, self, function()
            self.player_deck:reset()
            self.player_deck:shuffle()
            self.player_deck:deal_cards()

            self:update_sprites()
            self.render_manager.draw_objects_foreground["player_card_1"].dy = 4
            self.render_manager.draw_objects_foreground["player_card_2"].dy = 4
            self.render_manager.draw_objects_foreground["player_card_3"].dy = 4

            self.event_manager:remove_owner(self)
        end
    )
end


function GameScene:exit()
    self.event_manager:remove_owner(self)
end


function GameScene:draw_debug()
    local y = 10

    if not self.player.hand then
        love.graphics.print("hand = nil", 10, y)
        return
    end

    for i, card in ipairs(self.player.hand) do
        if card then
            love.graphics.print(i .. ": " .. card.name, 10, y)
        else
            love.graphics.print(i .. ": nil", 10, y)
        end
        y = y + 20
    end
end


return GameScene
