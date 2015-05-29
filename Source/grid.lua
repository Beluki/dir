
-- Meve.
-- A simple, minimalistic puzzle game.


require 'constant'
require 'util'


-- Grid appearing tiles animation.
-- Increases/decreases size/alpha values to make a "snap" animation.

-- Constructor:
function appearing_new ()
    local self = {}

    -- variables:
    self.enabled = false
    self.state = 'growing'
    self.size = 0
    self.alpha = 0

    -- constants:
    self.grow_speed = 300
    self.grow_max = 125

    self.shrink_speed = -100
    self.shrink_min = 100

    self.alpha_max = 255
    self.alpha_speed = self.grow_speed * 2.5

    return self
end

-- Reset the animation settings:
function appearing_reset (self)
    self.enabled = false
    self.state = 'growing'
    self.size = 0
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

-- Update the animation logic:
function appearing_update (self, dt)
    if self.enabled then
        if self.state == 'growing' then
            appearing_update_growing(self, dt)
        else
            appearing_update_shrinking(self, dt)
        end
    end
end

-- Start animation:
function appearing_enable (self)
    self.enabled = true
end

-- Stop animation:
function appearing_disable (self)
    self.enabled = false
end


-- Grid disappearing tiles animation.
-- Just growing and fading out.

-- Constructor:
function disappearing_new ()
    local self = {}

    -- variables:
    self.enabled = false
    self.size = 100
    self.alpha = 255

    -- constants:
    self.grow_speed = 100
    self.alpha_min = 0
    self.alpha_speed = -500

    return self
end

-- Reset the animation settings:
function disappearing_reset (self)
    self.enabled = false
    self.size = 100
    self.alpha = 255
end

-- Update the animation logic:
function disappearing_update (self, dt)
    if self.enabled then
        self.alpha = math.max(self.alpha + (self.alpha_speed * dt), self.alpha_min)
        self.size = self.size + (self.grow_speed * dt)

        if self.alpha == self.alpha_min then
            self.enabled = false
        end
    end
end

-- Start animation:
function disappearing_enable (self)
    self.enabled = true
end

-- Stop animation:
function disappearing_disable (self)
    self.enabled = false
end


-- Grid activating tiles animation.
-- Tiles grow to the big size.

-- Constructor:
function activating_new (self)
    local self = {}

    -- variables:
    self.enabled = false
    self.size = TILE_SIZE_SMALL

    -- constants:
    self.size_max = TILE_SIZE_BIG
    self.speed = 100

    return self
end

-- Reset the animation settings:
function activating_reset (self)
    self.enabled = false
    self.size = TILE_SIZE_SMALL
end

-- Update the animation logic:
function activating_update (self, dt)
    if self.enabled then
        self.size = math.min(self.size + (self.speed * dt), self.size_max)

        if self.size == self.size_max then
            self.enabled = false
        end
    end
end

-- Start animation:
function activating_enable (self)
    self.enabled = true
end

-- Stop animation:
function activating_disable (self)
    self.enabled = false
end


-- Grid moving tiles animation.
-- Tiles change their offset until a distance is reached.

-- Constructor:
function moving_new (self)
    local self = {}

    -- variables:
    self.enabled = false
    self.distance = 0
    self.moved = 0
    self.direction = nil
    self.speed = 0

    return self
end

-- Reset the animation settings:
function moving_reset (self, distance, direction)
    self.enabled = false
    self.distance = distance
    self.moved = 0
    self.direction = direction
    self.speed = self.distance * 1.5
end

-- Update the animation logic:
function moving_update (self, dt)
    if self.enabled then
        if self.moved < self.distance then
            local distance_x = self.direction.X * (self.speed * dt)
            local distance_y = self.direction.Y * (self.speed * dt)

            self.moved = math.min(self.moved +  distance_x + distance_y, self.distance)
        else
            self.enabled = false
        end
    end
end

-- Start animation:
function moving_enable (self)
    self.enabled = true
end

-- Stop animation:
function moving_disable (self)
    self.enabled = false
end


-- Grid:

-- Constructor:
function grid_new ()
    local self = {}

    self.tiles = {}

    self.appearing = appearing_new()
    self.disappearing = disappearing_new()
    self.activating = activating_new()
    self.moving = moving_new()

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
function grid_count_nil (self)
    local total = 0

    for x = 1, GRID_TILE_WIDTH do
        for y = 1, GRID_TILE_HEIGHT do
            if self.tiles[x][y] == nil then
                total = total + 1
            end
        end
    end

    return total
end

-- Get the (x, y) coordinates for the nth nil tile in the grid:
function grid_nth_nil (self, nth)
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
    local total_nil = grid_count_nil(self)

    -- no free positions available:
    if total_nil == 0 then
        return nil
    end

    appearing_reset(self.appearing)
    appearing_enable(self.appearing)

    local position = math.random(total_nil)
    local x, y = grid_nth_nil(self, position)

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
    local count = percentage * (total / 100)

    grid_add_random_tiles(self, count)
end

-- Draw the background squares:
function grid_draw_background (self)
    local offset = (TILE_SIZE_BIG - TILE_SIZE_SMALL) / 2

    for y = 1, GRID_TILE_HEIGHT do
        for x = 1, GRID_TILE_WIDTH do
            local screen_x = offset + GRID_X + ((x - 1) * TILE_SIZE_BIG)
            local screen_y = offset + GRID_Y + ((y - 1) * TILE_SIZE_BIG)

            draw_square(screen_x, screen_y, TILE_SIZE_SMALL, BACKGROUND_TILE_COLOR)
        end
    end
end

-- Draw tiles, use fn(self, tile, options) to determine the alpha/size/offset...:
function grid_draw_tiles_fn (self, fn)
    local offset = (TILE_SIZE_BIG - TILE_SIZE_SMALL) / 2

    for y = 1, GRID_TILE_HEIGHT do
        for x = 1, GRID_TILE_WIDTH do
            local tile = self.tiles[x][y]

            if tile ~= nil then
                local screen_x = GRID_X + ((x - 1) * TILE_SIZE_BIG)
                local screen_y = GRID_Y + ((y - 1) * TILE_SIZE_BIG)

                local R = tile.color.R
                local G = tile.color.G
                local B = tile.color.B

                -- default:
                local options = {}

                options.alpha = 255
                options.size = TILE_SIZE_SMALL
                options.offset_x = offset
                options.offset_y = offset

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
    options.size = (self.appearing.size * TILE_SIZE_SMALL) / 100

    -- same offset in the x, y coordinates:
    local offset = (TILE_SIZE_BIG - options.size) / 2

    options.offset_x = offset
    options.offset_y = offset

    return true
end

-- Determine options used to draw a disappearing tile:
function grid_draw_disappearing_tiles_fn(self, tile, options)
    if not tile.disappearing then
        return false
    end

    options.alpha = self.disappearing.alpha
    options.size = (self.disappearing.size * TILE_SIZE_SMALL) / 100

    -- same offset in the x, y coordinates:
    local offset = (TILE_SIZE_BIG - options.size) / 2

    options.offset_x = offset
    options.offset_y = offset

    return true
end

-- Determine options used to draw an activating tile:
function grid_draw_activating_tiles_fn(self, tile, options)
    if (not tile.activating) and (not tile.activated) then
        return false
    end

    options.alpha = 255

    if tile.activating then
        options.size = self.activating.size
    else
       options.size = TILE_SIZE_BIG
    end

    -- same offset in the x, y coordinates:
    local offset = (TILE_SIZE_BIG - options.size) / 2

    options.offset_x = offset
    options.offset_y = offset

    return true
end

-- Determine options used to draw a moving tile:
function grid_draw_moving_tiles_fn(self, tile, options)
    if not tile.moving then
        return false
    end

    options.alpha = 255
    options.size = TILE_SIZE_SMALL

    -- same offset in the x, y coordinates:
    local offset = (TILE_SIZE_BIG - options.size) / 2

    options.offset_x = offset + self.moving.moved * self.moving.direction.X
    options.offset_y = offset + self.moving.moved * self.moving.direction.Y

    return true
end

-- Draw the grid:
function grid_draw (self)
    grid_draw_background(self)

    grid_draw_tiles_fn(grid, grid_draw_static_tiles_fn)
    grid_draw_tiles_fn(grid, grid_draw_appearing_tiles_fn)
    grid_draw_tiles_fn(grid, grid_draw_disappearing_tiles_fn)
    grid_draw_tiles_fn(grid, grid_draw_activating_tiles_fn)
    grid_draw_tiles_fn(grid, grid_draw_moving_tiles_fn)
end

-- Update the grid logic:
function grid_update (self, dt)

    -- update animations state:
    appearing_update(self.appearing, dt)
    disappearing_update(self.disappearing, dt)
    activating_update(self.activating, dt)
    moving_update(self.moving, dt)

    -- update tiles state:
    for y = 1, GRID_TILE_HEIGHT do
        for x = 1, GRID_TILE_WIDTH do
            local tile = self.tiles[x][y]

            if tile ~= nil then
                if not self.appearing.enabled then
                    tile.appearing = false
                end
                if not self.disappearing.enabled then
                    if tile.disappearing then
                        self.tiles[x][y] = nil
                    end
                end

                if not self.activating.enabled then
                    if tile.activating then
                        tile.activating = false
                        tile.activated = true
                    end
                end
            end
        end
    end
end

