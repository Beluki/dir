
-- Meve.
-- A simple, minimalistic puzzle game.


require 'constant'
require 'tile'
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
            self.state = 'shrinking'
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
        if tile.animated then
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
                local distance_x = math.abs(self.direction.X * (self.speed * dt))
                local distance_y = math.abs(self.direction.Y * (self.speed * dt))

                self.moved = math.min(self.moved + distance_x + distance_y, self.distance)
            else
                self.enabled = false
            end
        end
    end

    -- get drawing values for a tile using this animation:
    self.draw_tile_options = function (tile, options)
        if tile.animated then
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
function grid_new()
    local self = {}

    -- variables:
    self.tiles = {}
    self.tiles_animation = nil

    self.appearing = appearing_new()
    self.disappearing = disappearing_new()
    self.activating = activating_new()
    self.moving = moving_new()

    -- methods:
    -- tiles array manipulation:

    -- determine if a (x, y) coordinate is inside the grid:
    self.valid_tile_position = function (x, y)
        return (x >= 1) and (y >= 1) and (x <= GRID_TILE_WIDTH) and (y <= GRID_TILE_HEIGHT)
    end

    -- set all the tiles in the grid to the nil value:
    self.clear = function ()
        for x = 1, GRID_TILE_WIDTH do
            self.tiles[x] = {}

            for y = 1, GRID_TILE_HEIGHT do
                self.tiles[x][y] = nil
            end
        end
    end

    -- count the number of tiles in the grid matching a function:
    self.count = function (test)
        local total = 0

        for x = 1, GRID_TILE_WIDTH do
            for y = 1, GRID_TILE_HEIGHT do
                if test(self.tiles[x][y]) then
                    total = total + 1
                end
            end
        end

        return total
    end

    -- count the number of nil tiles in the grid:
    self.count_nil = function ()
        local test = function (tile)
            return tile == nil
        end

        return self.count(test)
    end

    -- count the number of nil tiles in a given direction
    -- from a starting position:
    self.count_nil_direction = function (x, y, direction)
        local count = 0

        while true do
            x = x + direction.X
            y = y + direction.Y

            if not self.valid_tile_position(x, y) or self.tiles[x][y] ~= nil then
                return count
            end

            count = count + 1
        end
    end

    -- count the number of non-nil tiles in the grid:
    self.count_not_nil = function ()
        local test = function (tile)
            return tile ~= nil
        end

        return self.count(test)
    end

    -- get the (x, y) coordinates for the nth tile matching a function:
    self.nth = function (nth, test)
        for x = 1, GRID_TILE_WIDTH do
            for y = 1, GRID_TILE_HEIGHT do
                if test(self.tiles[x][y]) then
                    nth = nth - 1

                    if nth == 0 then
                        return x, y
                    end
                end
            end
        end
    end

    -- get the (x, y) coordinates for the nth nil tile in the grid:
    self.nth_nil = function (nth)
        local test = function (cell)
            return cell == nil
        end

        return self.nth(nth, test)
    end

    -- add a random colored tile in a random position in the grid
    -- using a set of possible colors:
    self.add_random_tile = function (colors)
        local total_nil = self.count_nil()

        -- no free positions available:
        if total_nil == 0 then
            return nil
        end

        local position = math.random(total_nil)
        local x, y = self.nth_nil(position)

        local tile = tile_new_random(colors)

        self.tiles_animation = self.appearing
        self.tiles_animation.enable()
        tile.animated = true

        self.tiles[x][y] = tile
    end

    -- add N random tiles:
    self.add_random_tiles = function (count, colors)
        for i = 1, count do
            self.add_random_tile(colors)
        end
    end

    -- add random tiles to the grid until a certain percentage is filled:
    self.add_random_tiles_filling = function (percentage, colors)
        local total = GRID_TILE_WIDTH * GRID_TILE_HEIGHT

        local used = total - self.count_nil()
        local required = percentage * (total / 100)

        while used < required do
            self.add_random_tile(colors)
            used = used + 1
        end
    end

    -- methods:
    -- animation handling:

    self.moving_done = function ()
        local distance_x = self.moving.direction.X * (self.moving.distance / TILE_SIZE_BIG)
        local distance_y = self.moving.direction.Y * (self.moving.distance / TILE_SIZE_BIG)

        -- reset tiles and change their position
        -- to the new value:

        for y = 1, GRID_TILE_HEIGHT do
            for x = 1, GRID_TILE_WIDTH do
                local tile = self.tiles[x][y]

                if tile ~= nil and tile.animated then
                    self.tiles[x][y] = nil
                    self.tiles[x + distance_x][y + distance_y] = tile
                    tile.animated = false
                end
            end
        end
    end

    -- reset animation settings after using it:
    self.animation_done = function ()
        if self.tiles_animation == self.moving then
            self.moving_done()
        else
            for y = 1, GRID_TILE_HEIGHT do
                for x = 1, GRID_TILE_WIDTH do
                    local tile = self.tiles[x][y]

                    if tile ~= nil and tile.animated then
                        tile.animated = false
                    end
                end
            end
        end

        self.tiles_animation = nil
    end

    -- methods:
    -- drawing and updating:

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

    -- draw tiles
    -- use fn(tile, options) to determine the alpha/size/offset:
    self.draw_tiles = function (fn)
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

    -- options used to draw a static tile:
    self.draw_static_tiles_options = function (tile, options)
        return not tile.animated
    end

    -- draw the grid:
    self.draw = function ()
        self.draw_background()
        self.draw_tiles(self.draw_static_tiles_options)

        if self.tiles_animation then
            self.draw_tiles(self.tiles_animation.draw_tile_options)
        end
    end

    -- update the grid logic:
    self.update = function (dt)
        if self.tiles_animation then
            self.tiles_animation.update(dt)

            if not self.tiles_animation.enabled then
                self.animation_done()
            end
        end
    end

    -- methods:
    -- input:

    -- get the (x, y) coordinates for the tile under the mouse cursor:
    self.mouse_tile_position = function (mouse_x, mouse_y)
        local x = math.floor((mouse_x - GRID_X) / TILE_SIZE_BIG) + 1
        local y = math.floor((mouse_y - GRID_Y) / TILE_SIZE_BIG) + 1

        return x, y, self.tiles[x][y]
    end

    -- handle input:
    self.mousepressed = function (mouse_x, mouse_y, button)
        -- no move during animations:
        if self.tiles_animation then
            return
        end

        local direction = MOUSE_DIRECTIONS[button]

        -- unknown direction:
        if direction == nil then
            return
        end

        local x, y = self.mouse_tile_position(mouse_x, mouse_y)
        local tile = self.tiles[x][y]

        -- no tile or not movable:
        if tile == nil or tile.active then
            return
        end

        local distance = self.count_nil_direction(x, y, direction) * TILE_SIZE_BIG

        -- can't move 0 pixels:
        if distance == 0 then
            return
        end

        self.tiles_animation = self.moving
        self.tiles_animation.reset(distance, direction)
        self.tiles_animation.enable()

        tile.animated = true
    end

    self.clear()
    return self
end

