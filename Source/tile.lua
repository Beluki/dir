
-- dir.
-- A simple, minimalistic puzzle game.


-- Create a new tile:
function Tile (color)
    local self = {}

    self.color = color
    self.match = false
    self.animated = false

    return self
end

-- Create a new tile using a random color from a list:
function RandomTile (colors)
    local index = math.random(#colors)
    local color = colors[index]

    return Tile(color)
end

