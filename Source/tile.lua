
-- dir.
-- A simple, minimalistic puzzle game.


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

-- Create a new tile using a random color from a list:
function RandomTile (colors)
    local index = math.random(#colors)
    local color = colors[index]

    return Tile(color)
end

