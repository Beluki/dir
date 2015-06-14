
-- dir.
-- A simple, minimalistic puzzle game.


require 'lib/love2d'


-- The hud displays information about the current game
-- above the grid, including score, combo and level.


function Hud (game)
    local self = {}

    -- initialization:
    self.init = function (game)
        self.game = game

        self.base_font_size = 0

        self.score_font_path = "resources/LiberationSans-Regular.ttf"
        self.score_font_size = 0
        self.score_font = nil

        self.combo_font_path = "resources/LiberationSans-Regular.ttf"
        self.combo_font_size = 0
        self.combo_font = nil

        self.level_font_path = "resources/LiberationSans-Regular.ttf"
        self.level_font_size = 0
        self.level_font = nil
    end

    -- reload the font sizes from the screen:
    self.reload_fonts = function ()
        local screen = self.game.screen

        self.base_font_size = screen.hud_base_font_size

        self.score_font_size = (self.base_font_size / 2)
        self.score_font = love2d.graphics_new_font(self.score_font_path, self.score_font_size)

        self.combo_font_size = (self.base_font_size / 3)
        self.combo_font = love2d.graphics_new_font(self.combo_font_path, self.combo_font_size)

        self.level_font_size = (self.base_font_size / 2.5)
        self.level_font = love2d.graphics_new_font(self.level_font_path, self.level_font_size)
    end

    -- draw the hud:
    self.draw = function ()
        local gamestate = self.game.gamestate
        local screen = self.game.screen
        local theme = self.game.theme

        -- when the base font changes, reload the fonts:
        if self.base_font_size ~= screen.hud_base_font_size then
            self.reload_fonts(screen)
        end

        -- top margin for each text:
        local top_margin = (screen.tile_size / 10)

        -- text:
        local score_text = gamestate.score
        local score_x = screen.grid_x
        local score_y = screen.hud_y + top_margin

        local combo_text = gamestate.combo .. "x"
        local combo_x = screen.grid_x
        local combo_y = screen.hud_y + (screen.hud_height / 2) + top_margin

        if gamestate.combo_score > 0 then
            combo_text =  combo_text .. " +" .. gamestate.combo_score
        end

        local level_text = "level " .. gamestate.level
        local level_x = screen.grid_x + screen.grid_width - self.level_font:getWidth(level_text)
        local level_y = screen.hud_y + (screen.hud_height / 2) - top_margin

        love2d.draw_text(score_text, score_x, score_y, theme.hud_font, self.score_font)
        love2d.draw_text(combo_text, combo_x, combo_y, theme.hud_font, self.combo_font)
        love2d.draw_text(level_text, level_x, level_y, theme.hud_font, self.level_font)
    end

    -- update logic:
    self.update = function (dt)
    end

    -- handle input:
    self.mousepressed = function (x, y, button)
    end

    self.init(game)
    return self
end

