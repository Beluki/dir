
-- dir.
-- A simple, minimalistic puzzle game.


-- Levels go from 1 to N with specific rules for the first six.
-- After level 6 the rules are the same, because it is the sweep
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
        self.combo = 0
        self.level = 0

        -- current combo score:
        self.combo_score = 0

        -- pending matches to advance level:
        self.matches_to_next_level = 0

        -- current level rules:
        self.tiles_after_clear = 0
        self.tiles_after_combo = 0
        self.tile_colors = 0
    end

    -- load the rules for the current level:
    self.load_level = function ()
        local level = KnownLevels[self.level]

        if level then
            self.tiles_after_clear = level.tiles_after_clear
            self.tiles_after_combo = level.tiles_after_combo
            self.tile_colors = level.tile_colors
        end
    end

    -- restart the game:
    self.restart = function ()
        self.score = 0
        self.combo = 1
        self.level = 1

        -- current combo score:
        self.combo_score = 0

        -- pending matches to advance level:
        self.matches_to_next_level = 25

        self.load_level()
        self.game.grid.add_random_tiles(self.tile_colors, self.tiles_after_clear)
    end

    -- update when new tiles have been added:
    self.appearing_completed = function (tile_count)
    end

    -- update when tiles have been cleared:
    self.disappearing_completed = function (tile_count)
        local grid = self.game.grid

        -- clear: add bonus and continue combo:
        if grid.is_empty() then
            self.combo_score = (self.combo_score * (self.level + 1))
            grid.add_random_tiles(self.tile_colors, self.tiles_after_clear)

        -- combo finished:
        else
            self.score = self.score + self.combo_score

            self.combo = 1
            self.combo_score = 0

            grid.add_random_tiles(self.tile_colors, self.tiles_after_combo)

            -- advance level as needed:
            if self.matches_to_next_level <= 0 then
                self.matches_to_next_level = 25
                self.level = self.level + 1
                self.load_level()
            end
        end
    end

    -- update when tiles have matched:
    self.growing_completed = function (tile_count)
        local grid = self.game.grid

        -- scoring:
        local tile_value = 10 + (25 - self.matches_to_next_level)
        local move_score = tile_value * tile_count * self.level * self.combo

        self.combo_score = self.combo_score + move_score
        self.combo = self.combo + 1

        self.matches_to_next_level = self.matches_to_next_level - 1
    end

    -- update when a move has been done:
    self.moving_completed = function ()
    end

    self.init(game)
    return self
end

