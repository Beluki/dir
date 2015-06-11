
-- dir.
-- A simple, minimalistic puzzle game.


function GameState ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.score = 0

        self.level = 1
        self.moves = 0

        self.combo = 1
        self.combo_score = 0

        self.colors = 2
        self.tiles = 5
    end

    -- update when new tiles have been added:
    self.appearing_completed = function (count)
    end

    -- update when tiles have been cleared:
    self.disappearing_completed = function (tile_count, grid)
        self.score = self.score + self.combo_score

        -- if the grid is was cleared, add bonus:
        if grid.is_empty() then
            grid.add_random_tiles_filling(30, self.colors)
        else
            self.combo = 1
            self.combo_score = 0
            grid.add_random_tiles(self.tiles, self.colors)
        end
    end

    -- update when tiles have matched:
    self.growing_completed = function (tile_count)
        self.combo_score = self.combo_score + (self.combo * (tile_count * 2) * (self.colors + self.tiles)) + self.moves
        self.combo = self.combo + 1
    end

    -- update when a move has been done:
    self.moving_completed = function ()
        self.moves = self.moves + 1

        if (self.moves % 25) == 0 then
            self.level = self.level + 1
        end

        if self.level == 2 then
            self.colors = 3
            self.tiles = 5
        end

        if self.level == 3 then
            self.colors = 4
            self.tiles = 5
        end

        if self.level == 4 then
            self.colors = 5
            self.tiles = 5
        end

        if self.level == 5 then
            self.colors = 5
            self.tiles = 6
        end

        if self.level == 6 then
            self.colors = 5
            self.tiles = 7
        end
    end

    self.init()
    return self
end

