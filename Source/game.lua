
-- dir.
-- A simple, minimalistic puzzle game.


require 'lib/love2d'

require 'constant'
require 'gamestate'
require 'grid'
require 'hud'
require 'screen'
require 'theme'


-- The Game object glues all the other components together
-- and provides callbacks for Love2D.


-- Create a new game object:
function Game ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.grid_width = 5
        self.grid_height = 5

        self.gamestate = GameState(self)
        self.hud = Hud(self)
        self.grid = Grid(self)
        self.screen = Screen(self)
        self.theme = ThemeLight(self)

        self.resize()
        self.restart()
    end

    -- Restart the game:
    self.restart = function ()
        self.grid.tiles.clear()
        self.gamestate.restart()
    end

    -- callbacks:

    -- draw the game:
    self.draw = function ()
        love2d.graphics_set_background_color(self.theme.background)

        self.hud.draw()
        self.grid.draw()
    end

    -- update the game logic:
    self.update = function (dt)
        self.hud.update(dt)
        self.grid.update(dt)
    end

    -- update the element sizes and positions on resize:
    self.resize = function (window_width, window_height)
        local width = window_width or love2d.window_width()
        local height = window_height or love2d.window_height()

        self.screen.resize(width, height)
    end

    -- handle keyboard input:
    self.keypressed = function (key)
        if key == 'escape' then
            love2d_event_quit()

        elseif key =='f' then
            love2d.window_toggle_fullscreen()

        elseif key == 'r' then
            self.restart()
        end
    end

    -- handle mouse input:
    self.mousepressed = function (x, y, button)
        local component = self.point_to_component(x, y)

        if component then
            component.mousepressed(x, y, button)
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

