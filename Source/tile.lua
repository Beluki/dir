
-- Meve.
-- A simple, minimalistic puzzle game.


-- Constructor:
function tile_new (color)
    local self = {}

    self.color = color
    self.pulsing = false
    self.appearing = true

    return self
end

-- Constructor, random color from a list:
function tile_new_random (colors)
    local index = math.random(#colors)
    local color = colors[index]

    return tile_new(color)
end

-- Determine if a tile is static (non-moving, non-appearing/dissapearing):
function tile_is_static (self)
    return not self.appearing
end

