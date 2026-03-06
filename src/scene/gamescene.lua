local Class = require("lib.class")

local GameScene = Class{}

local Deck = require("src.entity.deck")
local Enemy = require("src.entity.enemy")


function GameScene:init(GAME_STATE, RENDER_MANAGER, EVENT_MANAGER)
    self.game_state = GAME_STATE
    self.render_manager = RENDER_MANAGER
    self.event_manager = EVENT_MANAGER

    self.player = self.game_state.player

    -- Set animation timers
    self.animation_dealing = 0
end


function GameScene:animate_dealing(dt)
    self.animation_dealing = self.animation_dealing + 1

    if self.player then
        self.player:update(dt)

        if #self.player.hand > 0 and #self.player.deck.cards > 0 then
            if self.animation_dealing == 1 then
                self.render_manager.draw_objects_foreground["hud_player_deck"].dscale = 1.2
                self.render_manager.text_objects["player_deck"].dx = 3
                self.render_manager.draw_objects_foreground["player_card_1"].dy = -24
            end
            
            if self.animation_dealing < 6 then
                self.render_manager.draw_objects_foreground["player_card_2"].dx = -90
            elseif self.animation_dealing == 6 then
                self.render_manager.draw_objects_foreground["player_card_2"].dx = -9
                self.render_manager.draw_objects_foreground["player_card_2"].dy = -26
            end

            if self.animation_dealing < 11 then
                self.render_manager.draw_objects_foreground["player_card_3"].dx = -180
            elseif self.animation_dealing == 11 then
                self.render_manager.draw_objects_foreground["player_card_3"].dx = -18
                self.render_manager.draw_objects_foreground["player_card_3"].dy = -28
            end
        end
    end

    if self.enemy then
        self.enemy:update(dt)

        if #self.enemy.hand > 0 and #self.enemy.deck.cards > 0 then
            if self.animation_dealing < 1 then
                self.render_manager.draw_objects_foreground["enemy_card_1"].dx = 180
            elseif self.animation_dealing == 1 then
                self.render_manager.draw_objects_foreground["hud_enemy_deck"].dscale = 1.2
                self.render_manager.text_objects["enemy_deck"].dx = -3
                self.render_manager.draw_objects_foreground["enemy_card_1"].dx = 0
                self.render_manager.draw_objects_foreground["enemy_card_1"].dy = -35
            end
            
            if self.animation_dealing < 6 then
                self.render_manager.draw_objects_foreground["enemy_card_2"].dx = 180
            elseif self.animation_dealing == 6 then
                self.render_manager.draw_objects_foreground["enemy_card_2"].dx = 9
                self.render_manager.draw_objects_foreground["enemy_card_2"].dy = -37
            end

            if self.animation_dealing < 11 then
                self.render_manager.draw_objects_foreground["enemy_card_3"].dx = 180
            elseif self.animation_dealing == 11 then
                self.render_manager.draw_objects_foreground["enemy_card_3"].dx = 18
                self.render_manager.draw_objects_foreground["enemy_card_3"].dy = -39
            end
        end
    end
end

function GameScene:update(dt)
    -- Run card dealing animation
    self:animate_dealing()
end


function GameScene:draw()
    love.graphics.setColor(1, 1, 1, 1)

    if self.player then
        self.player:draw()
    end
end


function GameScene:enter()
    self:setup_events()
    
    self.enemy = Enemy()
    self.enemy.deck = Deck(self.enemy)
    self.enemy.hand = {}

    self.player.hand = {}

    self.event_manager:trigger(self.event_manager.events.SHUFFLEDECK)

    self:update_sprites()
    self.render_manager:set_shadow_colour(self.render_manager.colours.GREEN5)

    -- Nod screen items
    self.render_manager.draw_objects_background["background"].dscale = 0.1
    self.render_manager.draw_objects_foreground["table"].dy = 4

    -- Nod player items
    if self.player then
        self.render_manager.draw_objects_foreground["player"].dy = 4
        self.render_manager.draw_objects_foreground["hud_player_head"].dy = 4
        self.render_manager.draw_objects_foreground["hud_player_health"].dy = 4
        self.render_manager.draw_objects_foreground["hud_player_money"].dy = 4
        self.render_manager.draw_objects_foreground["hud_player_deck"].dy = 4
        self.render_manager.text_objects["player_name"].dy = 4
        self.render_manager.text_objects["player_health"].dy = 4
        self.render_manager.text_objects["player_money"].dy = 4
        self.render_manager.text_objects["player_deck"].dy = 4
    end

    if self.enemy then
        self.render_manager.draw_objects_foreground["enemy"].dy = 4
        self.render_manager.draw_objects_foreground["hud_enemy_head"].dy = 4
        self.render_manager.draw_objects_foreground["hud_enemy_health"].dy = 4
        self.render_manager.draw_objects_foreground["hud_enemy_deck"].dy = 4
        self.render_manager.text_objects["enemy_name"].dy = 4
        self.render_manager.text_objects["enemy_health"].dy = 4
        self.render_manager.text_objects["enemy_deck"].dy = 4
    end

end


function GameScene:update_sprites()
    self.render_manager:clear_screen()
    self.render_manager:create_draw_object_background("background", "background", "green", 96, 54, 0, 1, 255)
    self.render_manager:create_draw_object_foreground("table", "table", "1", 96, 91.5, 0, 1, 128)

    if self.player then
        -- Draw player
        self.render_manager:create_draw_object_foreground("player", "player", "idle", 66, 80, 0, 1, 128)

        -- Draw player's hud (icons)
        self.render_manager:create_draw_object_foreground("hud_player_head", "player", "head", 20, 20, 0, 1, 128)
        self.render_manager:create_draw_object_foreground("hud_player_health", "icons", "heart", 15.5, 34.5, 0, 1, 128)
        self.render_manager:create_draw_object_foreground("hud_player_money", "icons", "money", 15.5, 45.5, 0, 1, 128)
        self.render_manager:create_draw_object_foreground("hud_player_deck", "icons", "cards", 15.5, 56.5, 0, 1, 140)

        -- Draw player's hud (text)
        self.render_manager:create_text_object("player_name", "Player 1", self.render_manager.colours.YELLOW1, 34, 17, 0, 1, 64, "left")
        self.render_manager:create_text_object("player_health", tostring(self.player.health) .. "/" .. tostring(self.player.max_health), self.render_manager.colours.RED1, 22, 32, 0, 1, 64, "left")
        self.render_manager:create_text_object("player_money", "$" .. tostring(self.player.money), self.render_manager.colours.YELLOW1, 22, 43, 0, 1, 64, "left")
        self.render_manager:create_text_object("player_deck", tostring(#self.player.deck.cards), self.render_manager.colours.BROWN1, 22, 54, 0, 1, 64, "left")
        
        -- Draw player's hand
        if #self.player.hand > 0 then
            for i, card in ipairs(self.player.hand) do
                self.render_manager:create_draw_object_foreground("player_card_" .. i, "cards_" .. card.suit, card.value, 8.5 + (9 * i), 79.5 + (3 * i), 0, 1, 128+i)
            end
        end
    end

    if self.enemy then
        -- Draw enemy
        self.render_manager:create_draw_object_foreground("enemy", "enemy1", "idle", 126, 80, 0, 1, 128)
        
        -- Draw enemy's hud (icons)
        self.render_manager:create_draw_object_foreground("hud_enemy_head", "enemy1", "head", 172, 20, 0, 1, 128)
        self.render_manager:create_draw_object_foreground("hud_enemy_health", "icons", "heart", 176.5, 34.5, 0, 1, 128)
        self.render_manager:create_draw_object_foreground("hud_enemy_deck", "icons", "cards", 176.5, 45.5, 0, 1, 140)
        
        -- Draw enemy's hud (text)
        self.render_manager:create_text_object("enemy_name", "Enemy", self.render_manager.colours.YELLOW1, 159, 17, 0, 1, 64, "right")
        self.render_manager:create_text_object("enemy_health", tostring(self.enemy.health), self.render_manager.colours.RED1, 171, 32, 0, 1, 64, "right")
        self.render_manager:create_text_object("enemy_deck", tostring(#self.enemy.deck.cards), self.render_manager.colours.BROWN1, 171, 43, 0, 1, 64, "right")
        
        -- Draw enemy's hand
        if #self.player.hand > 0 then
            for i, card in ipairs(self.enemy.hand) do
                self.render_manager:create_draw_object_foreground("enemy_card_" .. i, "cards_" .. card.suit, card.value, 183.5 - (9 * i), 79.5 + (3 * i), 0, 1, 128+i)
            end
        end
    end
end


function GameScene:setup_events()
    -- Shuffle and reset the deck on shuffle command
    self.event_manager:on(
        self.event_manager.events.SHUFFLEDECK, self, function()
            self.player.deck:reset()
            self.player.deck:shuffle()

            if self.enemy then
                self.enemy.deck:reset()
                self.enemy.deck:shuffle()
            end
        end
    )

    -- Deal cards to the player on deal cards command
    self.event_manager:on(
        self.event_manager.events.DEALCARDS, self, function()
            self.animation_dealing = 0

            if #self.player.deck.cards >= 3 then
                self.player.deck:deal_cards()
            end
            
            if self.enemy then
                if #self.enemy.deck.cards >= 3 then
                    self.enemy.deck:deal_cards()
                end
            end

            self:update_sprites()
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
