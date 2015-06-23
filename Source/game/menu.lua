
-- dir.
-- A simple, minimalistic puzzle game.


require 'lib/love2d'
require 'game/util'


-- Create a new button:
local function MenuButton ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.text = ""
        self.x = 0
        self.y = 0
        self.width = 0
        self.height = 0
    end

    -- handle input:
    self.mousepressed = function (x, y, button)
    end

    return self
end


-- Create the menu:
function Menu (game)
    local self = {}

    -- initialization:
    self.init = function (game)
        self.game = game

        self.font_size = 0
        self.font_path = "resources/LiberationSans-Regular.ttf"

        self.text_font_size = 0
        self.text_font = nil

        self.button1 = MenuButton()
        self.button2 = MenuButton()
        self.button3 = MenuButton()

        self.button1.mousepressed = self.button1_mousepressed
        self.button2.mousepressed = self.button2_mousepressed
        self.button3.mousepressed = self.button3_mousepressed
    end

    -- reloading sizes:

    -- reload the font sizes from the screen:
    self.reload_fonts = function ()
        local screen = self.game.screen

        self.font_size = screen.menu_font_size

        self.text_font_size = self.font_size / 2
        self.text_font = love2d.graphics_new_font(self.font_path, self.text_font_size)
    end

    -- reload the button sizes:
    self.reload_buttons = function ()
        local screen = self.game.screen

        -- button text:
        self.button1.text = "restart"
        self.button2.text = "full screen"
        self.button3.text = "theme"

        -- change button 2 text as needed:
        if love2d.window_is_fullscreen() then
            self.button2.text = "windowed"
        end

        -- button sizes:
        self.button1.width = self.text_font:getWidth(self.button1.text)
        self.button1.height = self.text_font:getHeight(self.button1.text)

        self.button2.width = self.text_font:getWidth(self.button2.text)
        self.button2.height = self.text_font:getHeight(self.button2.text)

        self.button3.width = self.text_font:getWidth(self.button3.text)
        self.button3.height = self.text_font:getHeight(self.button3.text)

        -- button positions:
        local top_margin = screen.tile_size / 10

        local base_x = screen.grid_x
        local base_y = screen.menu_y + top_margin

        self.button1.x = base_x
        self.button1.y = base_y

        self.button2.x = base_x + (screen.grid_width / 2) - (self.button2.width / 2)
        self.button2.y = base_y

        self.button3.x = base_x + screen.grid_width - self.button3.width
        self.button3.y = base_y
    end

    -- drawing:

    -- draw the menu:
    self.draw = function ()
        local screen = self.game.screen
        local theme = self.game.theme

        -- when the base font changes, reload the fonts:
        if self.font_size ~= screen.menu_font_size then
            self.reload_fonts()
        end

        -- reload the button sizes and positions:
        self.reload_buttons()

        -- draw:
        love2d.draw_text(self.button1.text, self.button1.x, self.button1.y, theme.menu_font, self.text_font)
        love2d.draw_text(self.button2.text, self.button2.x, self.button2.y, theme.menu_font, self.text_font)
        love2d.draw_text(self.button3.text, self.button3.x, self.button3.y, theme.menu_font, self.text_font)
    end

    -- input:

    -- determine if a point is inside a menu button:
    self.point_inside_button = function (x, y, button)
        return point_inside_rect(x, y, button.x, button.y, button.width, button.height)
    end

    -- determine what menu button a point lies in:
    self.point_to_button = function (x, y)
        if self.point_inside_button(x, y, self.button1) then
            return self.button1
        end

        if self.point_inside_button(x, y, self.button2) then
            return self.button2
        end

        if self.point_inside_button(x, y, self.button3) then
            return self.button3
        end
    end

    -- handle input:
    self.mousepressed = function (x, y, button)
        local component = self.point_to_button(x, y)

        if component ~= nil then
            component.mousepressed(x, y, button)
        end
    end

    -- button 1: restart the game:
    self.button1_mousepressed = function (x, y, button)
        self.game.restart()
    end

    -- button 2: toggle between full screen and windowed:
    self.button2_mousepressed = function (x, y, button)
        love2d.window_toggle_fullscreen()
    end

    -- button 3: load the next theme:
    self.button3_mousepressed = function (x, y, button)
        self.game.theme.load_next_theme()
    end

    self.init(game)
    return self
end

