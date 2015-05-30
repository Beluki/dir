
-- Meve.
-- A simple, minimalistic puzzle game.


require 'constant'
require 'util'


-- Grid animations.
-- Those are tween-like and work with percentages.


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

    -- methods:

    -- reset the animation settings:
    self.reset = function ()
        self.enabled = false
        self.state = 'growing'
        self.size = 0
        self.alpha = 0
    end

    -- update the animation when growing:
    self.update_growing = function (dt)
        self.size = math.min(self.size + (self.grow_speed * dt), self.grow_max)
        self.alpha = math.min(self.alpha + (self.alpha_speed * dt), self.alpha_max)

        if self.size == self.grow_max then
            self.alpha = self.alpha_max
            self.state = 'shrink'
        end
    end

    -- update the animation when shrinking:
    self.update_shrinking = function (dt)
        self.size = math.max(self.size + (self.shrink_speed * dt), self.shrink_min)

        if self.size == self.shrink_min then
            self.enabled = false
        end
    end

    -- update the animation logic:
    self.update = function (dt)
        if self.enabled then
            if self.state == 'growing' then
                self.update_growing(dt)
            else
                self.update_shrinking(dt)
            end
        end
    end

    -- get drawing values for a tile using this animation:
    self.draw_tile_options = function (tile, options)
        if tile.appearing then
            options.alpha = self.alpha
            options.size = (self.size * TILE_SIZE_SMALL) / 100

            -- same offset in the x, y coordinates:
            local offset = (TILE_SIZE_BIG - options.size) / 2

            options.offset_x = offset
            options.offset_y = offset

            return true
        end
    end

    -- start animation:
    self.enable = function ()
        self.enabled = true
    end

    -- stop animation:
    self.disable = function ()
        self.enabled = false
    end

    return self
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

    -- methods:

    -- reset the animation settings:
    self.reset = function ()
        self.enabled = false
        self.size = 100
        self.alpha = 255
    end

    -- update the animation logic:
    self.update = function (dt)
        if self.enabled then
            self.alpha = math.max(self.alpha + (self.alpha_speed * dt), self.alpha_min)
            self.size = self.size + (self.grow_speed * dt)

            if self.alpha == self.alpha_min then
                self.enabled = false
            end
        end
    end

    -- get drawing values for a tile using this animation:
    self.draw_tile_options = function (tile, options)
        if tile.disappearing then
            options.alpha = self.alpha
            options.size = (self.size * TILE_SIZE_SMALL) / 100

            -- same offset in the x, y coordinates:
            local offset = (TILE_SIZE_BIG - options.size) / 2

            options.offset_x = offset
            options.offset_y = offset

            return true
        end
    end

    -- start animation:
    self.enable = function ()
        self.enabled = true
    end

    -- stop animation:
    self.disable = function ()
        self.enabled = false
    end

    return self
end


-- Grid activating tiles animation.
-- Tiles grow to the big size.

-- Constructor:
function activating_new ()
    local self = {}

    -- variables:
    self.enabled = false
    self.size = TILE_SIZE_SMALL

    -- constants:
    self.size_max = TILE_SIZE_BIG
    self.speed = 100

    -- methods:

    -- reset the animation settings:
    self.reset = function ()
        self.enabled = false
        self.size = TILE_SIZE_SMALL
    end

    -- update the animation logic:
    self.update = function (dt)
        if self.enabled then
            self.size = math.min(self.size + (self.speed * dt), self.size_max)

            if self.size == self.size_max then
                self.enabled = false
            end
        end
    end

    -- get drawing values for a tile using this animation:
    self.draw_tile_options = function (tile, options)
        if tile.activating then
            options.alpha = 255
            options.size = self.size

            -- same offset in the x, y coordinates:
            local offset = (TILE_SIZE_BIG - self.size) / 2

            options.offset_x = offset
            options.offset_y = offset

            return true
        end
    end

    -- start animation:
    self.enable = function ()
        self.enabled = true
    end

    -- stop animation:
    self.disable = function ()
        self.enabled = false
    end

    return self
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

    -- methods:

    -- reset the animation settings:
    self.reset = function (distance, direction)
        self.enabled = false
        self.distance = distance
        self.moved = 0
        self.direction = direction
        self.speed = self.distance * 1.5
    end

    -- update the animation logic:
    self.update = function (dt)
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

    -- get drawing values for a tile using this animation:
    self.draw_tile_options = function (tile, options)
        if tile.moving then
            options.alpha = 255
            options.size = TILE_SIZE_SMALL

            -- base offset:
            local offset = (TILE_SIZE_BIG - TILE_SIZE_SMALL) / 2

            options.offset_x = offset + (self.moved * self.direction.X)
            options.offset_y = offset + (self.moved * self.direction.Y)

            return true
        end
    end

    -- start animation:
    self.enable = function ()
        self.enabled = true
    end

    -- stop animation:
    self.disable = function ()
        self.enabled = false
    end

    return self
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

    self.animation = nil

    -- methods:

    -- set all the tiles in the grid to the nil value:
    self.clear = function ()
        for x = 1, GRID_TILE_WIDTH do
            self.tiles[x] = {}

            for y = 1, GRID_TILE_HEIGHT do
                self.tiles[x][y] = nil
            end
        end
    end

    -- count the number of nil tiles in the grid:
    self.count_nil = function ()
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

    -- get the (x, y) coordinates for the nth nil tile in the grid:
    self.nth_nil = function (nth)
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

    -- add a random colored tile in a random position in the grid:
    self.add_random_tile = function ()
        local total_nil = self.count_nil()

        -- no free positions available:
        if total_nil == 0 then
            return nil
        end

        self.animation = self.appearing
        self.appearing.reset()
        self.appearing.enable()

        local position = math.random(total_nil)
        local x, y = self.nth_nil(position)

        self.tiles[x][y] = tile_new_random(TILE_COLORS)
    end

    -- add N random tiles:
    self.add_random_tiles = function (count)
        for i = 1, count do
            self.add_random_tile()
        end
    end

    -- add random tiles to the grid until a certain percentage is filled:
    -- (does nothing if this percentage is already satisfied)
    self.add_random_filling = function (percentage)
        local total = GRID_TILE_WIDTH * GRID_TILE_HEIGHT

        local used = total - self.count_nil()
        local required = percentage * (total / 100)

        for count = used, required do
            self.add_random_tile()
        end
    end

    -- draw the background squares:
    self.draw_background = function ()
        local offset = (TILE_SIZE_BIG - TILE_SIZE_SMALL) / 2

        for y = 1, GRID_TILE_HEIGHT do
            for x = 1, GRID_TILE_WIDTH do
                local screen_x = offset + GRID_X + ((x - 1) * TILE_SIZE_BIG)
                local screen_y = offset + GRID_Y + ((y - 1) * TILE_SIZE_BIG)

                draw_square(screen_x, screen_y, TILE_SIZE_SMALL, BACKGROUND_TILE_COLOR)
            end
        end
    end

    -- draw tiles, use fn(tile, options) to determine the alpha/size/offset...:
    self.draw_tiles_fn = function (fn)
        local offset = (TILE_SIZE_BIG - TILE_SIZE_SMALL) / 2
        local options = {}

        for y = 1, GRID_TILE_HEIGHT do
            for x = 1, GRID_TILE_WIDTH do
                local tile = self.tiles[x][y]

                if tile ~= nil then
                    local R = tile.color.R
                    local G = tile.color.G
                    local B = tile.color.B

                    options.alpha = 255
                    options.size = TILE_SIZE_SMALL
                    options.offset_x = offset
                    options.offset_y = offset

                    if fn(tile, options) then
                        local screen_x = GRID_X + ((x - 1) * TILE_SIZE_BIG) + options.offset_x
                        local screen_y = GRID_Y + ((y - 1) * TILE_SIZE_BIG) + options.offset_y

                        draw_square(screen_x, screen_y, options.size, { R, G, B, options.alpha })
                    end
                end
            end
        end
    end

    -- determine options used to draw a static tile:
    self.draw_static_tiles_fn = function (tile, options)
        return tile.is_static()
    end

    -- draw the grid:
    self.draw = function ()
        self.draw_background()
        self.draw_tiles_fn(self.draw_static_tiles_fn)

        if self.animation ~= nil then
            self.draw_tiles_fn(self.animation.draw_tile_options)
        end
    end

    -- update the grid logic:
    self.update = function (dt)

        -- update animation state:
        if self.animation ~= nil then
            self.animation.update(dt)
        end

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

    return self
end

