
-- dir.
-- A simple, minimalistic puzzle game.


require 'lib/love2d'


function Hud (state)
    local self = {}

    -- initialization:
    self.init = function (state)
        self.state = state
        self.base_font_size = 0

        self.score_font_size = 0
        self.score_font = nil
        self.score_x = 0
        self.score_y = 0

        self.combo_font_size = 0
        self.combo_font = nil
        self.combo_x = 0
        self.combo_y = 0
    end

    -- reload the font sizes from the screen:
    self.reload_fonts = function (screen)
        self.base_font_size = screen.hud_font_size

        self.score_font_size = self.base_font_size / 2
        self.score_font = love.graphics.newFont("resources/LiberationSans-Bold.ttf", self.score_font_size)
        self.score_x = screen.grid_x
        self.score_y = screen.hud_y + (self.score_font_size / 6)

        self.combo_font_size = self.base_font_size / 3
        self.combo_font = love.graphics.newFont("resources/LiberationSans-Bold.ttf", self.combo_font_size)
        self.combo_x = screen.grid_x
        self.combo_y = screen.hud_y + (screen.hud_height / 2) + (self.combo_font_size / 3)
    end

    -- draw the hud:
    self.draw = function (screen, theme)
         if self.base_font_size ~= screen.hud_font_size then
             self.reload_fonts(screen)
         end

        draw_text(self.state.score, self.score_x, self.score_y, theme.hud_font, self.score_font)
        draw_text(self.state.combo .. "x", self.combo_x, self.combo_y, theme.hud_font, self.combo_font)
        draw_text("level " .. self.state.level, screen.hud_width, self.combo_y, theme.hud_font, self.combo_font)
    end

    -- update the score:
    self.update = function (dt)
    end

    self.init(state)
    return self
end

