
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

        self.score = 0
        self.score_x = 0
        self.score_y = 0
        self.score_speed = 3
    end

    -- reload the font sizes from the screen:
    self.reload_fonts = function (screen)
        self.base_font_size = screen.hud_font_size

        self.score_font_size = self.base_font_size / 2
        self.score_font = love.graphics.newFont("resources/LiberationSans-Bold.ttf", self.score_font_size)

        self.score_x = screen.hud_x + (self.score_font_size / 4)
        self.score_y = screen.hud_y + (self.score_font_size / 2)
    end

    -- draw the hud:
    self.draw = function (screen, theme)
        if self.base_font_size ~= screen.hud_font_size then
            self.reload_fonts(screen)
        end

        draw_text(math.floor(self.score), self.score_x, self.score_y, theme.hud_font, self.score_font)
    end

    -- update the score:
    self.update = function (dt)
        if self.score < self.state.score then
            local difference = self.state.score - self.score

            if difference < 1000 then
                self.score = self.state.score
            else
                local added = difference * self.score_speed * dt
                self.score = math.min(self.score + added, self.state.score)
            end
        end
    end

    self.init(state)
    return self
end

