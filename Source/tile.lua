
-- Meve.
-- A simple, minimalistic puzzle game.


-- Constructor:
function tile_new (color)
    local self = {}

    self.color = color
    self.activated = false

    self.appearing = true
    self.disappearing = false
    self.activating = false
    self.moving = false

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
    return (not self.appearing) and (not self.disappearing) and (not self.moving)
end

