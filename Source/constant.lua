
-- dir.
-- A simple, minimalistic puzzle game.

-- Size percentages:
TILE_SIZE_SMALL_PERCENTAGE = 60
TILE_SIZE_SMALL_GROW_PERCENTAGE = (100 / TILE_SIZE_SMALL_PERCENTAGE) * 100

-- All the available tile colors:
TILE_COLORS = {
    { R = 255, G =  50, B =  50 }, -- red
    { R =  35, G = 217, B =  82 }, -- green
    { R =  22, G = 127, B = 252 }, -- blue
    { R = 255, G = 221, B =  47 }, -- yellow
    { R = 255, G =  89, B = 220 }, -- purple
}

BACKGROUND_TILE_COLOR = { 240, 240, 240 }

--
-- TILE_COLORS = {
--    { R = 255, G =  24, B = 115 },
--    { R =  13, G = 255, B = 242 },
--    { R = 255, G = 205, B =  25 },
--    { R = 167, G =  87, B = 171 },
--    { R =  24, G = 255, B =  30 },
-- }

-- Background tiles color:
-- BACKGROUND_TILE_COLOR = { 10, 10, 10 }

-- Movement coordinates:
DIRECTIONS = {
    UP    = { x =  0, y = -1 },
    RIGHT = { x =  1, y =  0 },
    DOWN  = { x =  0, y =  1 },
    LEFT  = { x = -1, y =  0 },
}

-- Mouse button -> movement coordinate:
MOUSE_DIRECTIONS = {
    ['wu'] = DIRECTIONS.UP,
    ['r']  = DIRECTIONS.RIGHT,
    ['wd'] = DIRECTIONS.DOWN,
    ['l']  = DIRECTIONS.LEFT,
}

