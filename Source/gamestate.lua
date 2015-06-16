
-- dir.
-- A simple, minimalistic puzzle game.


-- Levels go from 1 to N with specific rules for the first six.
-- After level 6 the rules are the same, because it is the sweet
-- spot between "hard enough" and "impossible".


local KnownLevels = {
    -- Level 1
    {
        tiles_after_clear = 9,
        tiles_after_combo = 5,
        tile_colors = 2,
    },
    -- Level 2
    {
        tiles_after_clear = 8,
        tiles_after_combo = 5,
        tile_colors = 3,

    },
    -- Level 3
    {
        tiles_after_clear = 7,
        tiles_after_combo = 5,
        tile_colors = 4,
    },
    -- Level 4
    {
        tiles_after_clear = 6,
        tiles_after_combo = 5,
        tile_colors = 5,
    },
    -- Level 5
    {
        tiles_after_clear = 5,
        tiles_after_combo = 6,
        tile_colors = 5,
    },
    -- Level 6
    {
        tiles_after_clear = 5,
        tiles_after_combo = 7,
        tile_colors = 5,
    },
}


-- Create a new gamestate object:
function GameState (game)
    local self = {}

    -- initialization:
    self.init = function (game)
        self.game = game
        self.score = 0

        -- current combo multiplier, total tiles, and score:
        self.combo = 0
        self.combo_tiles = 0
        self.combo_score = 0

        -- level number and ruleset:
        self.level = 0
        self.rules = nil

        -- base match value, pending matches to advance level:
        self.match_value = 0
        self.matches_to_next_level = 0
    end

    -- restart the game:
    self.restart = function ()
        self.score = 0

        -- current combo multiplier, total tiles, and score:
        self.combo = 1
        self.combo_tiles = 0
        self.combo_score = 0

        -- level number and ruleset:
        self.level = 1
        self.rules = self.load_rules(self.level)

        -- base match value, pending matches to advance level:
        self.match_value = 10
        self.matches_to_next_level = 25

        -- start game:
        self.game.grid.add_random_tiles(self.rules.tile_colors, self.rules.tiles_after_clear)
    end

    -- load the rules for the current level:
    self.load_rules = function ()
        local index = math.min(self.level, #KnownLevels)

        return KnownLevels[index]
    end

    -- decide how many points the current combo tiles are worth:
    self.calculate_combo_score = function ()
        return self.match_value * self.combo_tiles * self.combo * self.level
    end

    -- update when new tiles have been added:
    self.appearing_completed = function (tile_count)
    end

    -- update when tiles have been cleared:
    self.disappearing_completed = function (tile_count)
        local grid = self.game.grid

        -- clear: add bonus and continue combo:
        -- (the bonus is the score for the total tiles in the combo again)
        if grid.is_empty() then
            self.combo_score = self.combo_score + self.calculate_combo_score()
            grid.add_random_tiles(self.rules.tile_colors, self.rules.tiles_after_clear)

        -- combo finished:
        else
            self.score = self.score + self.combo_score

            self.combo = 1
            self.combo_tiles = 0
            self.combo_score = 0

            grid.add_random_tiles(self.rules.tile_colors, self.rules.tiles_after_combo)

            -- advance level as needed:
            if self.matches_to_next_level <= 0 then
                self.matches_to_next_level = 25

                self.level = self.level + 1
                self.rules = self.load_rules()
            end
        end
    end

    -- update when tiles have matched:
    self.growing_completed = function (tile_count)
        local grid = self.game.grid

        self.combo_tiles = self.combo_tiles + tile_count
        self.combo_score = self.combo_score + self.calculate_combo_score()
        self.combo = self.combo + 1

        self.matches_to_next_level = self.matches_to_next_level - 1
    end

    -- update when a move has been done:
    self.moving_completed = function ()
    end

    self.init(game)
    return self
end

