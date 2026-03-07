local Class = require("lib.class")

local Token = Class{}


function Token:init(tag, type, name, effect, cost, unlocked)
    self.tag = tag
    self.type = type
    self.name = name
    self.effect = effect
    self.cost = cost
    self.unlocked = unlocked
end


Tokens = {
    -- Bullets
    BULLET_BRONZE = Token('bullet_bronze', 'bullet', 'bronze bullet', 2, 1, false),
    BULLET_SILVER = Token('bullet_bronze', 'bullet', 'silver bullet', 3, 2, false),
    BULLET_GOLD = Token('bullet_bronze', 'bullet', 'gold bullet', 5, 3, false),
    BULLET_TITANIUM = Token('bullet_titanium', 'bullet', 'titanium bullet', 5, 3, false),
    BULLET_URANIUM = Token('bullet_uranium', 'bullet', 'uranium', 5, 3, false),

    HEALTH_BEER = Token('health_beer', 'health', 'beer', 0, 0, false),
    HEALTH_WHISKY = Token('health_whisky', 'health', 'whisky', 0, 0, false),
}


return Tokens
