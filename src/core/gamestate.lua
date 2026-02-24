local Class = require("lib.class")

local Player = require("src.entity.player")

local GameState = Class{}


function GameState:init()
    self.player = Player()
end


function GameState:update(dt)
end


function GameState:draw()
end


return GameState
