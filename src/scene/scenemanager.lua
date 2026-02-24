local Class = require("lib.class")

local GameScene = require("src.scene.gamescene")

local SceneManager = Class{}


function SceneManager:init(GAME_STATE, RENDER_MANAGER)
    self.game_scene = GameScene(GAME_STATE, RENDER_MANAGER)

    self.current_scene = nil
    self:switch(self.game_scene)
end


function SceneManager:switch(new_scene)
    if self.current_scene and self.current_scene.exit then
        self.current_scene:exit()
    end

    self.current_scene = new_scene

    if self.current_scene.enter then
        self.current_scene:enter()
    end
end


function SceneManager:update(dt)
    if self.current_scene and self.current_scene.update then
        self.current_scene:update(dt)
    end
end


function SceneManager:draw()
    if self.current_scene and self.current_scene.draw then
        self.current_scene:draw()
    end
end


return SceneManager
