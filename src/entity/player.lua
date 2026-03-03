local Class = require("lib.class")

local Player = Class{}


States = {
    IDLE = 1,
}


function Player:init(controller)
    self.controller = controller
    self.state = States.IDLE
    self.x = 66
    self.y = 80
    
    self.health = 5
    self.max_health = 10
    self.money = 10
    self.animations = {}

    self.hand = {}
end


function Player:update(dt)
end


function Player:draw()
end


return Player
