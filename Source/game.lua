
-- dir.
-- A simple, minimalistic puzzle game.


require 'constant'
require 'grid'
require 'tile'


-- Create a new game object:
function Game()
    local self = {}

    self.grid = Grid()
    self.grid.add_random_tiles_filling(50, TILE_COLORS)

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
        self.grid.tween = self.grid.moving
        self.grid.tween.reset()
        self.grid.tween.play(TILE_SIZE_BIG, DIRECTIONS.RIGHT)
    end

    return self
end

