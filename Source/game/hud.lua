
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

        self.font_size = 0
        self.font_path = "resources/LiberationSans-Regular.ttf"

        self.score_font_size = 0
        self.score_font = nil
        self.score = 0

        self.combo_font_size = 0
        self.combo_font = nil

        self.level_font_size = 0
        self.level_font = nil
    end

    -- reset when restarting the game:
    self.restart = function ()
        self.score = 0
    end

    -- reload the font sizes from the screen:
    self.reload_fonts = function ()
        local screen = self.game.screen

        self.font_size = screen.hud_font_size

        self.score_font_size = (self.font_size / 2)
        self.score_font = love2d.graphics_new_font(self.font_path, self.score_font_size)

        self.combo_font_size = (self.font_size / 3)
        self.combo_font = love2d.graphics_new_font(self.font_path, self.combo_font_size)

        self.level_font_size = (self.font_size / 2.5)
        self.level_font = love2d.graphics_new_font(self.font_path, self.level_font_size)
    end

    -- draw the hud:
    self.draw = function ()
        local screen = self.game.screen
        local state = self.game.state
        local theme = self.game.theme

        -- when the base font changes, reload the fonts:
        if self.font_size ~= screen.hud_font_size then
            self.reload_fonts()
        end

        -- text that we will display:
        local score_text = self.score
        local combo_text = state.combo .. "x"
        local level_text = "level " .. state.level

        -- append the current combo score based on the multiplier:
        if state.combo_score > 0 then
            combo_text =  combo_text .. " +" .. state.combo_score
        end

        -- top margin for each text:
        local top_margin = (screen.tile_size / 10)

        -- calculate positions, base x = grid, base y = hud center + margin
        local font_x = screen.grid_x
        local font_y = screen.hud_y + (screen.hud_height / 2) + top_margin

        local score_x = font_x
        local score_y = font_y - self.score_font:getHeight(score_text)

        local combo_x = font_x
        local combo_y = font_y

        local level_x = font_x + (screen.grid_width - self.level_font:getWidth(level_text))
        local level_y = font_y - (self.score_font:getHeight(level_text) / 2)

        -- draw:
        love2d.draw_text(score_text, score_x, score_y, theme.hud_font, self.score_font)
        love2d.draw_text(combo_text, combo_x, combo_y, theme.hud_font, self.combo_font)
        love2d.draw_text(level_text, level_x, level_y, theme.hud_font, self.level_font)
    end

    -- increase the internal score closer to the actual game score:
    self.update_score = function (dt)
        local state = self.game.state

        if self.score < state.score then
            local difference = math.max(state.score - self.score, 100)
            local update = math.floor(difference * 10 * dt)

            self.score = math.min(self.score + update, state.score)
        end
    end

    -- update logic:
    self.update = function (dt)
        self.update_score(dt)
    end

    -- handle input:
    self.mousepressed = function (x, y, button)
    end

    self.init(game)
    return self
end

