
-- dir.
-- A simple, minimalistic puzzle game.


-- Grid size (tiles):
GRID_TILE_WIDTH = 6
GRID_TILE_HEIGHT = 5

-- Small tiles size percentage with respect to big tiles:
TILE_SIZE_SMALL_PERCENTAGE = 60
TILE_SIZE_SMALL_GROW_PERCENTAGE = (100 / TILE_SIZE_SMALL_PERCENTAGE) * 100


-- All the available tile colors:
TILE_COLORS = {
    {  255,   50,   50 }, -- red
    {   35,  217,   82 }, -- green
    {   22,  127,  252 }, -- blue
    {  255,  221,   47 }, -- yellow
    {  255,   89,  220 }, -- purple
}

BACKGROUND_TILE_COLOR = { 240, 240, 240 }


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

