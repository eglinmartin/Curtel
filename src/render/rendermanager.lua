local Class = require("lib.class")
local rs = require("lib.resolution_solution")

local RenderManager = Class{}


function RenderManager:init()
end


function RenderManager:update(dt)
end


function RenderManager:draw()
    love.graphics.setColor(75/255, 90/255, 87/255, 1)
    love.graphics.rectangle("fill", 0, 0, 192, 108)

    love.graphics.setColor(81/255, 108/255, 94/255, 1)
    love.graphics.rectangle("fill", 5, 5, 182, 98)
end


return RenderManager
