-- Require files in parent directory, not normally needed
package.path = package.path .. ';../?.lua'

local World = require 'World'
local System = require 'System'

local MovementSystem = System {
    depends = {'Position', 'Velocity'},
    run = function(targets, dt)
        for pos, vel in targets do
            pos.x = pos.x + dt * vel.x
            pos.y = pos.y + dt * vel.y
        end
    end
}

local CircleDrawSystem = System {
    depends = {'Position', 'CircleDraw'},
    run = function(targets)
        for pos, draw in targets do
            love.graphics.circle('line', pos.x, pos.y, draw.radius)
        end
    end
}

local world = World()
world:createEntity {
    {type = 'Position', x = 150, y = 200},
    {type = 'Velocity', x = 30, y = 5},
    {type = 'CircleDraw', radius = 10},
}
world:createEntity {
    {type = 'Position', x = 100, y = 100},
    {type = 'CircleDraw', radius = 20},
}

function love.update(dt)
    MovementSystem(world, dt)
end

function love.draw()
    CircleDrawSystem(world)
end
