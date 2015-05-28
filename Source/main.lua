
-- Meve.
-- A simple, minimalistic puzzle game.


require 'constant'
require 'grid'
require 'tile'


grid = grid_new()

-- Game initialization:
function love.load ()
    math.randomseed(os.time())

    grid_clear(grid)
    grid_fill(grid, 30)
end

-- Game logic update:
function love.update (dt)
    grid_update(grid, dt)
end

-- Game frame:
function love.draw ()
    love.graphics.setBackgroundColor({ 255, 255, 255 })

    grid_draw(grid)
end

function love.mousepressed ()
    grid_add_random_tiles(grid, 5)
end

