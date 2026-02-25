local Class = require("lib.class")

local EventManager = Class{}


local Events = {
    SWITCHSCREEN_GAME = 'switch screen to game',
    SWITCHSCREEN_SHOP = 'switch screen to shop',
    DEALCARDS = 'deal cards to player'
}


function EventManager:init()
    self.events = Events
    self.listeners = {} -- table storing callbacks for each event
end


function EventManager:on(event_id, owner, callback)
    self.listeners[event_id] = self.listeners[event_id] or {}

    table.insert(self.listeners[event_id], {
        owner = owner,
        callback = callback
    })
end


function EventManager:trigger(event_id)
    local listeners = self.listeners[event_id]
    if not listeners then return end

    for _, listener in ipairs(listeners) do
        listener.callback()
    end
end


function EventManager:remove_owner(owner)
    for event_id, listeners in pairs(self.listeners) do
        for i = #listeners, 1, -1 do
            if listeners[i].owner == owner then
                table.remove(listeners, i)
            end
        end
    end
end


return EventManager
