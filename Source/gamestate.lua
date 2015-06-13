
-- dir.
-- A simple, minimalistic puzzle game.


-- Level definition:

local LevelRules = {
    -- level 1:
    {
        clear_fill_percent = 30,
        deadlock_fill_percent = 30,

        match_tile_value = 10,

        new_tile_colors = 3,
        new_tile_count = 3,
    },
    -- level 2:
    {
        clear_fill_percent = 30,
        deadlock_fill_percent = 30,

        match_tile_value = 15,

        new_tile_colors = 3,
        new_tile_count = 5,
    },
}



function GameState (game)
    local self = {}

    -- initialization:
    self.init = function (game)
        self.game = game

        self.score = 0
        self.combo = 1
        self.level = 1

        -- percentage of the grid to fill at game start, after a clear or a deadlock:
        self.restart_fill_percent = 30
        self.clear_fill_percent = 0
        self.deadlock_fill_percent = 0

        -- score value for each tile matched:
        self.match_tile_value = 0

        -- number of tile colors on this level and number of tiles to add on no match:
        self.new_tile_colors = 0
        self.new_tile_count = 0
    end

    self.restart = function ()
        self.score = 0
        self.combo = 1
        self.level = 1

        self.load_level_rules()
        self.game.grid.add_random_tiles_filling(self.new_tile_colors, self.restart_fill_percent)
    end

    self.load_level_rules = function ()
        local rules = LevelRules[self.level]

        if rules then
            self.clear_fill_percent = rules.clear_fill_percent
            self.deadlock_fill_percent = rules.deadlock_fill_percent
            self.match_tile_value = rules.match_tile_value
            self.new_tile_colors = rules.new_tile_colors
            self.new_tile_count = rules.new_tile_count
        end
    end

    -- update when new tiles have been added:
    self.appearing_completed = function ()
    end

    -- update when tiles have been cleared:
    self.disappearing_completed = function ()

        -- if the grid is was cleared, add more tiles:
        if self.game.grid.is_empty() then
            self.game.grid.add_random_tiles_filling(self.new_tile_colors, self.clear_fill_percent)
        else
            self.combo = 1
            self.game.grid.add_random_tiles(self.new_tile_colors, self.new_tile_count)
        end

    end

    -- update when tiles have matched:
    self.growing_completed = function ()
    end

    -- update when a move has been done:
    self.moving_completed = function ()
    end

    self.init(game)
    return self
end

