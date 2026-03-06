local Class = require("lib.class")

local Deck = require("src.entity.deck")
local Player = require("src.entity.player")

local GameState = Class{}


function GameState:init()
    self.player = Player()
    self.player.deck = Deck(self.player)
end


function GameState:update(dt)
end


function GameState:draw()
end


return GameState
