
-- Meve.
-- A simple, minimalistic puzzle game.


require 'grid'


-- Constructor:
function game_new()
    local self = {}

    -- variables:
    self.grid = grid_new()

    -- methods:

    -- draw the game:
    self.draw = function ()
        love.graphics.setBackgroundColor(255, 255, 255)

        self.grid.draw()
        self.grid.add_random_tiles_filling(50, TILE_COLORS)
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

    return self
end

