local index = {}

function index:add(component)
    self.components[component.type] = component
end

function index:remove(componentOrType)
    if type(componentOrType) == 'table' then
        self.components[componentOrType.type] = nil
    else
        self.components[componentOrType] = nil
    end
end

return setmetatable({
    __index = index,
}, {
    __call = function(mt, components)
        local instance = setmetatable({components = {}}, mt)

        if type(components) == 'table' then
            for i = 1, #components do
                instance:add(components[i])
            end
        elseif components ~= nil then
            error(string.format(
                'expected components to be table or nil, not %s',
                type(components)), 2)
        end

        return instance
    end,
})