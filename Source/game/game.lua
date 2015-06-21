
-- dir.
-- A simple, minimalistic puzzle game.


require 'lib/love2d'

require 'game/grid'
require 'game/hud'
require 'game/screen'
require 'game/state'
require 'game/theme'


-- The Game object glues all the other components together
-- and provides callbacks for Love2D.


-- Create a new game object:
function Game ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.grid_width = 5
        self.grid_height = 5

        self.grid = Grid(self)
        self.hud = Hud(self)
        self.screen = Screen(self)
        self.state = State(self)
        self.theme = Theme(self)

        self.resize()
        self.restart()
    end

    -- restart the game:
    self.restart = function ()
        self.grid.restart()
        self.hud.restart()
        self.state.restart()
        self.theme.restart()
    end

    -- callbacks:

    -- draw the game:
    self.draw = function ()
        love2d.graphics_set_background_color(self.theme.background)

        self.grid.draw()
        self.hud.draw()
    end

    -- update the game logic:
    self.update = function (dt)
        self.grid.update(dt)
        self.hud.update(dt)
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
            love2d.event_quit()

        elseif key == '1' then
            self.theme.load_theme(1)

        elseif key == '2' then
            self.theme.load_theme(2)

        elseif key == '3' then
            self.theme.load_theme(3)

        elseif key =='f' then
            love2d.window_toggle_fullscreen()

        elseif key == 'r' then
            self.restart()

        elseif key == 't' then
            self.theme.load_next_theme()

        end
    end

    -- handle mouse input:
    self.mousepressed = function (x, y, button)
        local component = self.point_to_component(x, y)

        if component ~= nil then
            component.mousepressed(x, y, button)
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

