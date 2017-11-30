local function generatetargets(depends)
    local keys = {}
    local vals = {}
    local gets = {}

    for i = 1, #depends do
        keys[#keys + 1] = 'k' .. i
        vals[#vals + 1] = 'v' .. i
        gets[#gets + 1] = string.format('local v%d = cs[k%d]', i, i)
    end

    return string.format([[
return function(%s)
    return function(entities)
        local i = 0
        local n = #entities
        return function()
            while i < n do
                i = i + 1
                local cs = entities[i].components
                %s
                if %s then
                    return %s
                end
            end
        end
    end
end
    ]],
        table.concat(keys, ', '),
        table.concat(gets, '\n                '),
        table.concat(vals, ' and '),
        table.concat(vals, ', '))
end

local function buildtargets(code, depends)
    return assert(loadstring(code))()(unpack(depends))
end

return function(t)
    -- Verify arguments
    if type(t) ~= 'table' then
        error(string.format('expected table, not %s', type(t)), 2)
    end

    local depends = t.depends
    local run = t.run

    if type(depends) ~= 'table' then
        error(string.format('expected t.depends to be table, not %s',
        type(depends)), 2)
    end
    if #depends == 0 then
        error('a system must depend on at least one component', 2)
    end

    if type(run) ~= 'function' then
        error(string.format('expected t.run to be function, not %s',
            type(run)), 2)
    end

    -- Create targets function
    local code = generatetargets(depends)
    local status, targets = pcall(buildtargets, code, depends)

    if not status then
        print(code)
        error('Failed to build System targets function: ' .. targets)
    end

    -- Return System run function
    return function(world, ...)
        return run(targets(world.entities), ...)
    end
end