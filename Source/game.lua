
-- dir.
-- A simple, minimalistic puzzle game.


-- The Game object glues all the other components
-- and provides callbacks for Love2D.


require 'constant'
require 'grid'
require 'screen'
require 'tile'
require 'util'


-- Create a new game object:
function Game ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.grid = Grid(GRID_TILE_WIDTH, GRID_TILE_HEIGHT)
        self.screen = Screen(GRID_TILE_WIDTH, GRID_TILE_HEIGHT)

        self.resize()

        self.grid.add_random_tiles_filling(50, TILE_COLORS)
    end

    -- love callbacks:

    -- draw the game:
    self.draw = function ()
        love.graphics.setBackgroundColor(255, 255, 255)

        self.grid.draw(self.screen)
    end

    -- update the game logic:
    self.update = function (dt)
        self.grid.update(dt)
    end

    -- update the element sizes and positions on resize:
    self.resize = function (window_width, window_height)
        local width = window_width or love.window.getWidth()
        local height = window_height or love.window.getHeight()

        self.screen.update(width, height)
    end

    -- handle keyboard input:
    self.keypressed = function (key)
        if key == 'escape' then
            love.event.quit()
        elseif key == 'f' then
            toggle_fullscreen()
        end
    end

    -- handle mouse input:
    self.mousepressed = function (x, y, button)
        local component = self.point_to_component(x, y)

        if component ~= nil then
            component.mousepressed(self.screen, x, y, button)
        end
    end

    -- helpers:

    -- given a point in the window, determine which game component contains it:
    self.point_to_component = function (x, y)
        if self.screen.point_inside_grid(x, y) then
            return self.grid
        end
    end

    self.init()
    return self
end

