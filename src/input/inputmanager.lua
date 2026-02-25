local Class = require("lib.class")

local InputManager = Class{}


function InputManager:init(EVENT_MANAGER)
    self.event_manager = EVENT_MANAGER
end


function InputManager:keypressed(key)
    if key == "f1" then
        self.event_manager:trigger(self.event_manager.events.SWITCHSCREEN_GAME)
    end
    if key == "f2" then
        self.event_manager:trigger(self.event_manager.events.SWITCHSCREEN_SHOP)
    end
    if key == "f5" then
        self.event_manager:trigger(self.event_manager.events.NODPLAYER)
    end
end


return InputManager