
-- Meve.
-- A simple, minimalistic puzzle game.


-- Constructor:
function tile_new (color)
    local self = {}

    -- variables:
    self.color = color
    self.active = false
    self.animated = false

    return self
end

-- Constructor using a random color from a list:
function tile_new_random (colors)
    local index = math.random(#colors)
    local color = colors[index]

    return tile_new(color)
end

