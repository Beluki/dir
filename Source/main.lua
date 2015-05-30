
-- Meve.
-- A simple, minimalistic puzzle game.


require 'constant'
require 'grid'
require 'tile'


grid = grid_new()

-- Game initialization:
function love.load ()
    math.randomseed(os.time())

    grid.clear()
end

-- Game logic update:
function love.update (dt)
    grid.update(dt)
end

-- Game frame:
function love.draw ()
    love.graphics.setBackgroundColor({ 255, 255, 255 })

    grid.draw(grid)
end

function love.mousepressed (x, y, button)
    if button == 'l' then
        grid.add_random_tiles(5)
    end
end

