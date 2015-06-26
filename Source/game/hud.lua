
-- dir.
-- A simple, minimalistic puzzle game.


require 'lib/love2d'
require 'game/util'


-- The hud displays information about the current game
-- above the grid, including score, combo and level.


function Hud (game)
    local self = {}

    -- initialization:
    self.init = function (game)
        self.game = game

        self.font_size = 0
        self.font_path = "resources/LiberationSans-Regular.ttf"

        self.big_font_size = 0
        self.big_font = nil

        self.small_font_size = 0
        self.small_font = nil

        self.score = 0
    end

    -- reset when restarting the game:
    self.restart = function ()
        self.score = 0
    end

    -- reload the font sizes from the screen:
    self.reload_fonts = function ()
        local screen = self.game.screen

        self.font_size = screen.hud_font_size

        self.big_font_size = (self.font_size / 2)
        self.big_font = love2d.graphics_new_font(self.font_path, self.big_font_size)

        self.small_font_size = (self.font_size / 3)
        self.small_font = love2d.graphics_new_font(self.font_path, self.small_font_size)
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
        local score_text = separate_thousands(self.score)
        local combo_text = state.combo .. "x"
        local level_text = "level " .. state.level
        local rank_text = state.rank

        -- append the current combo score based on the multiplier:
        if state.combo_score > 0 then
            combo_text =  combo_text .. " +" .. separate_thousands(state.combo_score)
        end

        -- top margin for each text:
        local top_margin = (screen.tile_size / 10)

        -- calculate positions, base x = grid, base y = hud center + margin
        local base_x = screen.grid_x
        local base_y = screen.hud_y + (screen.hud_height / 2) + top_margin

        local score_x = base_x
        local score_y = base_y - self.big_font:getHeight(score_text)

        local combo_x = base_x
        local combo_y = base_y

        local level_x = base_x + screen.grid_width - self.big_font:getWidth(level_text)
        local level_y = base_y - self.big_font:getHeight(level_text)

        local rank_x = base_x + screen.grid_width - self.small_font:getWidth(rank_text)
        local rank_y = base_y

        -- draw:
        love2d.draw_text(score_text, score_x, score_y, theme.hud_font, self.big_font)
        love2d.draw_text(combo_text, combo_x, combo_y, theme.hud_font, self.small_font)
        love2d.draw_text(level_text, level_x, level_y, theme.hud_font, self.big_font)
        love2d.draw_text(rank_text, rank_x, rank_y, theme.hud_font, self.small_font)
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

    self.init(game)
    return self
end

