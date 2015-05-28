
-- Meve.
-- A simple, minimalistic puzzle game.


require 'constant'
require 'util'


-- Grid pulsing tiles animation:

-- Constructor:
function pulsing_new ()
    local self = {}

    self.enabled = true
    self.speed = -50
    self.brightness = 0
    self.min = -50
    self.max = 0

    return self
end

-- Update the pulse animation logic:
function pulsing_update (self, dt)
    if self.enabled then
        self.brightness = clamp(self.brightness + (self.speed * dt), self.min, self.max)

        if self.brightness == self.min or self.brightness == self.max then
            self.speed = -1 * self.speed
        end
    end
end

-- Reset the pulsing animation:
function pulsing_reset (self)
    self.speed = -50
    self.brightness = 0
end

-- Start pulsing:
function pulsing_enable (self)
    self.enabled = true
end

-- Stop pulsing:
function pulsing_disable (self)
    self.enabled = false
end


-- Grid appearing tiles animation:

-- Constructor:
function appearing_new ()
    local self = {}

    self.size = 50

    self.grow_speed = 175
    self.grow_max = 120

    self.shrink_speed = -100
    self.shrink_min = 100

    self.state = 'grow'
    self.enabled = false

    self.alpha = 0
    self.alpha_max = 255
    self.alpha_speed = self.grow_speed * 2.5

    return self
end

-- Reset the appearing animation settings:
function appearing_reset (self)
    self.size = 50
    self.state = 'grow'
    self.enabled = false
    self.alpha = 0
end

-- Update the appearing animation logic when growing:
function appearing_update_growing(self, dt)
    self.size = math.min(self.size + (self.grow_speed * dt), self.grow_max)
    self.alpha = math.min(self.alpha + (self.alpha_speed * dt), self.alpha_max)

    if self.size == self.grow_max then
        self.alpha = self.alpha_max
        self.state = 'shrink'
    end
end

-- Update the appearing animation logic when shrinking:
function appearing_update_shrinking(self, dt)
    self.size = math.max(self.size + (self.shrink_speed * dt), self.shrink_min)

    if self.size == self.shrink_min then
        self.enabled = false
    end
end

-- Update the appearing animation logic:
function appearing_update (self, dt)
    if self.enabled then
        if self.state == 'grow' then
            appearing_update_growing(self, dt)
        else
            appearing_update_shrinking(self, dt)
        end
    end
end

-- Start appearing:
function appearing_enable (self)
    self.enabled = true
end

-- Stop appearing:
function appearing_disable (self)
    self.enabled = false
end


-- Grid:

-- Constructor:
function grid_new ()
    local self = {}

    self.tiles = {}
    self.pulsing = pulsing_new()

    self.appearing = appearing_new()

    return self
end

-- Set all the tiles in the grid to the nil value:
function grid_clear (self)
    for x = 1, GRID_TILE_WIDTH do
        self.tiles[x] = {}

        for y = 1, GRID_TILE_HEIGHT do
            self.tiles[x][y] = nil
        end
    end
end

-- Count the number of nil tiles in the grid:
function grid_count_free (self)
    local total_free = 0

    for x = 1, GRID_TILE_WIDTH do
        for y = 1, GRID_TILE_HEIGHT do
            if self.tiles[x][y] == nil then
                total_free = total_free + 1
            end
        end
    end

    return total_free
end

-- Get the (x, y) coordinates for the nth free tile in the grid (0 to 49):
function grid_nth_free (self, nth)
    for x = 1, GRID_TILE_WIDTH do
        for y = 1, GRID_TILE_HEIGHT do
            if self.tiles[x][y] == nil then
                nth = nth - 1

                if nth == 0 then
                    return x, y
                end
            end
        end
    end
end

-- Add a random colored tile in a random position in the grid:
function grid_add_random_tile (self)
    local total_free = grid_count_free(self)

    -- no free positions available:
    if total_free == 0 then
        return nil
    end

    appearing_reset(self.appearing)
    appearing_enable(self.appearing)

    local position = math.random(total_free)
    local x, y = grid_nth_free(self, position)

    self.tiles[x][y] = tile_new_random(TILE_COLORS)
end

-- Add N random tiles:
function grid_add_random_tiles (self, count)
    while count > 0 do
        grid_add_random_tile(self)
        count = count - 1
    end
end

-- Add random tiles to the grid until a certain percent is filled:
function grid_fill (self, percentage)
    local total = GRID_TILE_WIDTH * GRID_TILE_HEIGHT

    local free = grid_count_free(self)
    local used = total - free

    local needed = percentage * (total / 100)

    while used < needed do
        grid_add_random_tile(self)
        used = used + 1
    end
end

-- Draw the background squares:
function grid_draw_background (self)
    local offset = (TILE_SIZE - BACKGROUND_TILE_SIZE) / 2

    for y = 1, GRID_TILE_HEIGHT do
        for x = 1, GRID_TILE_WIDTH do
            local screen_x = offset + GRID_X + ((x - 1) * TILE_SIZE)
            local screen_y = offset + GRID_Y + ((y - 1) * TILE_SIZE)

            draw_square(screen_x, screen_y, BACKGROUND_TILE_SIZE, BACKGROUND_TILE_COLOR)
        end
    end
end

-- Draw tiles, use fn(self, tile, options) to determine the alpha/size/offset...:
function grid_draw_tiles_fn (self, fn)
    local options = {}

    for y = 1, GRID_TILE_HEIGHT do
        for x = 1, GRID_TILE_WIDTH do
            local tile = self.tiles[x][y]

            if tile ~= nil then
                local screen_x = GRID_X + ((x - 1) * TILE_SIZE)
                local screen_y = GRID_Y + ((y - 1) * TILE_SIZE)

                local R = tile.color.R
                local G = tile.color.G
                local B = tile.color.B

                if tile.pulsing then
                    R = clamp(R + self.pulsing.brightness, 0, 255)
                    G = clamp(G + self.pulsing.brightness, 0, 255)
                    B = clamp(B + self.pulsing.brightness, 0, 255)
                end

                -- default:
                options.alpha = 255
                options.size = TILE_SIZE
                options.offset_x = 0
                options.offset_y = 0

                if fn(self, tile, options) then
                    screen_x = screen_x + options.offset_x
                    screen_y = screen_y + options.offset_y

                    draw_square(screen_x, screen_y, options.size, { R, G, B, options.alpha })
                end
            end
        end
    end
end

-- Determine options used to draw a static tile:
function grid_draw_static_tiles_fn(self, tile, options)
    return tile_is_static(tile)
end

-- Determine options used to draw a appearing tile:
function grid_draw_appearing_tiles_fn(self, tile, options)
    if not tile.appearing then
        return false
    end

    options.alpha = self.appearing.alpha
    options.size = (self.appearing.size * TILE_SIZE) / 100

    -- same offset in the x, y coordinates:
    offset = (TILE_SIZE - options.size) / 2

    options.offset_x = offset
    options.offset_y = offset

    return true
end

-- Draw the grid:
function grid_draw (self)
    grid_draw_background(self)

    grid_draw_tiles_fn(grid, grid_draw_static_tiles_fn)
    grid_draw_tiles_fn(grid, grid_draw_appearing_tiles_fn)
end

-- Update the grid logic:
function grid_update (self, dt)
    -- update animations state:
    pulsing_update(self.pulsing, dt)
    appearing_update(self.appearing, dt)

    -- update tiles state:
    for y = 1, GRID_TILE_HEIGHT do
        for x = 1, GRID_TILE_WIDTH do
            local tile = self.tiles[x][y]

            if tile ~= nil then
                if not self.appearing.enabled then
                    tile.appearing = false
                end
            end
        end
    end
end

