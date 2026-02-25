local Class = require("lib.class")

local EventManager = Class{}


local Events = {
    SWITCHSCREEN_GAME = 'switch screen to game',
    SWITCHSCREEN_SHOP = 'switch screen to shop'
}


function EventManager:init()
    self.events = Events
    self.listeners = {} -- table storing callbacks for each event
end


function EventManager:on(event_id, callback)
    self.listeners[event_id] = self.listeners[event_id] or {}
    table.insert(self.listeners[event_id], callback)
end


function EventManager:trigger(event_id)
    local callbacks = self.listeners[event_id]
    if callbacks then
        for _, callback in ipairs(callbacks) do
            callback()
        end
    end
end


return EventManager
