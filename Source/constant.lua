
-- Meve.
-- A simple, minimalistic puzzle game.


-- Tile size (pixels):
TILE_SIZE = 50

-- All the available tile colors to choose from:
TILE_COLORS = {
    { R = 255, G =  50, B =  50 }, -- red
    { R =  35, G = 217, B =  82 }, -- green
    { R =  22, G = 127, B = 252 }, -- blue
    { R = 255, G = 221, B =  47 }, -- yellow
    { R = 255, G =  89, B = 220 }, -- purple
    { R = 255, G = 150, B =  22 }, -- orange
    { R =   0, G = 217, B = 255 }, -- cyan
    { R = 182, G = 255, B =   0 }, -- lime
    { R = 255, G =   0, B = 110 }, -- pink
}

-- Tile colors count:
TILE_COLORS_COUNT = #TILE_COLORS

-- Background:
BACKGROUND_TILE_SIZE = 25
BACKGROUND_TILE_COLOR = { 240, 240, 240 }

-- Grid size (tiles):
GRID_TILE_WIDTH = 7
GRID_TILE_HEIGHT = 7

-- Grid drawing position/size (pixels):
GRID_X = 0
GRID_Y = TILE_SIZE

GRID_WIDTH = GRID_TILE_WIDTH * TILE_SIZE
GRID_HEIGHT = GRID_TILE_HEIGHT * TILE_SIZE

