
-- Meve.
-- A simple, minimalistic puzzle game.


-- Constructor:
function tile_new (color)
    local self = {}

    -- variables:
    self.color = color
    self.activated = false

    self.appearing = true
    self.disappearing = false
    self.activating = false
    self.moving = false

    -- methods:

    -- determine if a tile is not animated:
    self.is_static = function ()
        return (not self.appearing)
           and (not self.disappearing)
           and (not self.activating)
           and (not self.moving)
    end

    return self
end

-- Constructor, random color from a list:
function tile_new_random (colors)
    local index = math.random(#colors)
    local color = colors[index]

    return tile_new(color)
end

