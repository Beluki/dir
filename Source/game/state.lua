
-- dir.
-- A simple, minimalistic puzzle game.


-- Levels go from 1 to N with specific rules for the first six.
-- After level 6 the rules are the same, because it is the sweet
-- spot between "hard enough" and "impossible".


local Levels = {
    -- level 1
    {
        tiles_after_clear = 9,
        tiles_after_combo = 5,
        tile_colors = 2,
    },
    -- level 2
    {
        tiles_after_clear = 8,
        tiles_after_combo = 5,
        tile_colors = 3,

    },
    -- level 3
    {
        tiles_after_clear = 7,
        tiles_after_combo = 5,
        tile_colors = 4,
    },
    -- level 4
    {
        tiles_after_clear = 6,
        tiles_after_combo = 5,
        tile_colors = 5,
    },
    -- level 5
    {
        tiles_after_clear = 5,
        tiles_after_combo = 6,
        tile_colors = 5,
    },
    -- level 6...
    {
        tiles_after_clear = 5,
        tiles_after_combo = 7,
        tile_colors = 5,
    },
}

-- Rankings go from "novice" to "master" with a special "grandmaster" rank.
-- Rank is decided by score. Look in calculate_rank() for the conditions
-- to advance to "grandmaster".

local Ranks = {
    {
        name = "novice",
        score = 0,
    },
    {
        name = "beginner",
        score = 50000,
    },
    {
        name = "amateur",
        score = 125000,
    },
    {
        name = "experienced",
        score = 250000,
    },
    {
        name = "advanced",
        score = 450000,
    },
    {
        name = "expert",
        score = 700000,
    },
    {
        name = "master",
        score = 1000000,
    },
}



-- Create a new gamestate object:
function State (game)
    local self = {}

    -- initialization:
    self.init = function (game)
        self.game = game
        self.score = 0
        self.rank = nil

        -- current combo multiplier, total tiles, and score:
        self.combo = 0
        self.combo_tiles = 0
        self.combo_score = 0

        -- level number and ruleset:
        self.level = 1
        self.rules = self.load_rules()

        -- base match value, pending matches to advance level:
        self.match_value = 15
        self.matches_to_next_level = 25

        -- stats:
        self.best_combo = 0
    end

    -- restart the state:
    self.restart = function ()
        self.score = 0
        self.rank = self.calculate_rank()

        -- current combo multiplier, total tiles, and score:
        self.combo = 0
        self.combo_tiles = 0
        self.combo_score = 0

        -- level number and ruleset:
        self.level = 1
        self.rules = self.load_rules()

        -- base match value, pending matches to advance level:
        self.match_value = 15
        self.matches_to_next_level = 25

        -- stats:
        self.best_combo = 0

        -- start game:
        self.game.grid.add_random_tiles(self.rules.tile_colors, self.rules.tiles_after_clear)
    end

    -- load the rules for the current level:
    self.load_rules = function ()
        local index = math.min(self.level, #Levels)

        return Levels[index]
    end

    -- decide how many points the current combo tiles are worth:
    self.calculate_combo_score = function ()
        return self.match_value * self.combo_tiles * self.combo * self.level
    end

    -- decide the current game rank:
    self.calculate_rank = function ()
        local name = ""

        for index, rank in ipairs(Ranks) do
            if self.score >= rank.score then
                name = rank.name
            end
        end

        if name == "master" and self.best_combo >= 25 and self.level >= 20 then
            name = "grandmaster"
        end

        return name
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
            self.rank = self.calculate_rank()

            self.combo = 0
            self.combo_tiles = 0
            self.combo_score = 0

            -- add the new tiles before advancing level, giving the player a last turn
            -- to make a combo with the current rules:
            grid.add_random_tiles(self.rules.tile_colors, self.rules.tiles_after_combo)

            -- advance level:
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

        self.combo = self.combo + 1
        self.combo_tiles = self.combo_tiles + tile_count
        self.combo_score = self.combo_score + self.calculate_combo_score()

        self.matches_to_next_level = self.matches_to_next_level - 1

        self.best_combo = math.max(self.best_combo, self.combo)
    end

    -- update when a move has been done:
    self.moving_completed = function ()
    end

    self.init(game)
    return self
end

