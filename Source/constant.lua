
-- dir.
-- A simple, minimalistic puzzle game.


-- Tile sizes (pixels):
TILE_SIZE_BIG = 75
TILE_SIZE_SMALL = 40
TILE_SIZE_GROWTH = (TILE_SIZE_BIG * 100) / TILE_SIZE_SMALL

-- All the available tile colors:
TILE_COLORS = {
    { R = 255, G =  50, B =  50, A = 255 }, -- red
    { R =  35, G = 217, B =  82, A = 255 }, -- green
    { R =  22, G = 127, B = 252, A = 255 }, -- blue
    { R = 255, G = 221, B =  47, A = 255 }, -- yellow
    { R = 255, G =  89, B = 220, A = 255 }, -- purple
    { R = 255, G = 150, B =  22, A = 255 }, -- orange
    { R =   0, G = 217, B = 255, A = 255 }, -- cyan
    { R = 182, G = 255, B =   0, A = 255 }, -- lime
    { R = 255, G =   0, B = 110, A = 255 }, -- pink
}

-- Total tile colors:
TILE_COLORS_COUNT = #TILE_COLORS

-- Background small tiles color:
BACKGROUND_TILE_COLOR = { 240, 240, 240 }

-- Grid size (tiles):
GRID_TILE_WIDTH = 7
GRID_TILE_HEIGHT = 7

-- Grid drawing position and size (pixels):
GRID_X = 0
GRID_Y = TILE_SIZE_BIG

GRID_WIDTH = GRID_TILE_WIDTH * TILE_SIZE_BIG
GRID_HEIGHT = GRID_TILE_HEIGHT * TILE_SIZE_BIG

-- Movement coordinates:
DIRECTIONS = {
    UP    = { X =  0, Y = -1 },
    RIGHT = { X =  1, Y =  0 },
    DOWN  = { X =  0, Y =  1 },
    LEFT  = { X = -1, Y =  0 },
}

-- Mouse button -> movement coordinate:
MOUSE_DIRECTIONS = {
    ['wu'] = DIRECTIONS.UP,
    ['r']  = DIRECTIONS.RIGHT,
    ['wd'] = DIRECTIONS.DOWN,
    ['l']  = DIRECTIONS.LEFT,
}

