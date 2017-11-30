local requirepath = (...):match('(.-)[^%/%.]+$')
local Entity = require(requirepath .. 'Entity')

local index = {}

function index:addEntity(entity)
    self.entities[#self.entities + 1] = entity
end

function index:removeEntity(entity)
    for i = 1, #self.entities do
        if self.entities[i] == entity then
            table.remove(self.entities, i)
            return true
        end
    end

    return false
end

function index:removeEntityByIndex(index)
    table.remove(self.entities, index)
end

function index:createEntity(...)
    local entity = Entity(...)
    self:addEntity(entity)
    return entity
end

return setmetatable({
    __index = index,
}, {
    __call = function(mt)
        return setmetatable({
            entities = {},
        }, mt)
    end,
})
