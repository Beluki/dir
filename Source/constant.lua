
-- dir.
-- A simple, minimalistic puzzle game.


-- Grid size (in tiles):
GRID_WIDTH = 5
GRID_HEIGHT = 5

-- Small tiles size percentage with respect to big tiles:
TILE_SIZE_SMALL_PERCENTAGE = 60
TILE_SIZE_SMALL_GROW_PERCENTAGE = (100 / TILE_SIZE_SMALL_PERCENTAGE) * 100

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

