local Class = require("lib.class")

local InputManager = Class{}


function InputManager:init(EVENT_MANAGER)
    self.event_manager = EVENT_MANAGER
end


function InputManager:keypressed(key)
    if key == "1" then
        self.event_manager:trigger(self.event_manager.events.SWITCHSCREEN_GAME)
    end
    if key == "2" then
        self.event_manager:trigger(self.event_manager.events.SWITCHSCREEN_SHOP)
    end
    if key == "3" then
        self.event_manager:trigger(self.event_manager.events.DEALCARDS)
    end
end


return InputManager