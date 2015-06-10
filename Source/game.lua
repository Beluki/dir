
-- dir.
-- A simple, minimalistic puzzle game.


require 'constant'
require 'gamestate'
require 'grid'
require 'hud'
require 'screen'
require 'theme'


-- The Game object glues all the other components
-- and provides callbacks for Love2D.


-- Create a new game object:
function Game ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.gamestate = GameState()

        self.hud = Hud(self.gamestate)
        self.grid = Grid(GRID_WIDTH, GRID_HEIGHT, self.gamestate)

        self.screen = Screen(GRID_WIDTH, GRID_HEIGHT)
        self.theme = ThemeLight()
        self.resize()

        self.grid.add_random_tiles_filling(30, 3)
    end

    -- callbacks:

    -- draw the game:
    self.draw = function ()
        love.graphics.setBackgroundColor(self.theme.background)

        self.hud.draw(self.screen, self.theme)
        self.grid.draw(self.screen, self.theme)
    end

    -- update the game logic:
    self.update = function (dt)
        self.hud.update(dt)
        self.grid.update(dt)
    end

    -- update the element sizes and positions on resize:
    self.resize = function (window_width, window_height)
        local width = window_width or love.window.getWidth()
        local height = window_height or love.window.getHeight()

        self.screen.resize(width, height)
    end

    -- handle keyboard input:
    self.keypressed = function (key)
        if key == 'escape' then
            love.event.quit()
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
        if self.screen.point_inside_hud(x, y) then
            return self.hud
        end

        if self.screen.point_inside_grid(x, y) then
            return self.grid
        end
    end

    self.init()
    return self
end

