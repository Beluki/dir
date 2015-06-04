
-- dir.
-- A simple, minimalistic puzzle game.


require 'constant'
require 'grid'
require 'tile'
require 'util'


-- Create a new game object:
function Game()
    local self = {}

    -- initialization:
    self.init = function ()
        self.grid = Grid()
        self.grid.add_random_tiles_filling(50, TILE_COLORS)
    end

    -- draw the game:
    self.draw = function ()
        love.graphics.setBackgroundColor(255, 255, 255)

        self.grid.draw()
    end

    -- update the game logic:
    self.update = function (dt)
        self.grid.update(dt)
    end

    -- handle input:
    self.mousepressed = function (x, y, button)
        local component = self.point_to_component(x, y)

        if component ~= nil then
            component.mousepressed(x, y, button)
        end
    end

    -- given a point in the window, determine which game component contains it:
    self.point_to_component = function (x, y)
        if point_inside_rect(x, y, GRID_X, GRID_Y, GRID_WIDTH, GRID_HEIGHT) then
            return self.grid
        end
    end

    self.init()
    return self
end

