
-- dir.
-- A simple, minimalistic puzzle game.


function GameState ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.score = 0
        self.colors = 2
        self.tiles = 3
    end

    self.appearing_completed = function (count)
    end

    self.disappearing_completed = function (count)
        self.score = self.score + count
    end

    self.growing_completed = function (count)
    end

    self.moving_completed = function ()
    end

    self.init()
    return self
end

