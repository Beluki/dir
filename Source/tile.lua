
-- dir.
-- A simple, minimalistic puzzle game.


-- All the tiles have three properties:
-- .color is an index into the current theme colors.
-- .big determines whether the tile has matched neighbour tiles.
-- .animated is true when the tile is subject to the current grid animation.


-- Create a new tile:
function Tile (color)
    local self = {}

    -- initialization:
    self.init = function (color)
        self.color = color
        self.big = false
        self.animated = false
    end

    self.init(color)
    return self
end

