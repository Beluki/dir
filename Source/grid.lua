
-- dir.
-- A simple, minimalistic puzzle game.


require 'array2d'
require 'constant'
require 'tile'
require 'util'


-- Tile animations:

-- There are four animations, tiles appearing, disappearing, growing or moving.
-- One of them (or none) is active at any point during the gameplay.

-- The implementations are tween-like and work with percentages.
-- The idea is to keep animation logic separated from the grid semantics
-- and independent enough to be easy to understand in isolation.


-- A "snap into place" animation for appearing tiles:
function TilesAppearing ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.running = false
        self.finished = false

        self.size = 0
        self.alpha = 0
        self.offset_x = 0
        self.offset_y = 0

        self.state = 'growing'

        -- constant:
        self.grow_speed = 375
        self.grow_max = 125

        self.shrink_speed = 150
        self.shrink_min = 100

        self.alpha_max = 100
        self.alpha_speed = self.grow_speed * 2.5
    end

    -- reset the animation settings:
    self.reset = function ()
        self.init()
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
        self.size = math.max(self.size - (self.shrink_speed * dt), self.shrink_min)

        if self.size == self.shrink_min then
            self.running = false
            self.finished = true
            self.oncomplete()
        end
    end

    -- update the animation logic:
    self.update = function (dt)
        if not self.running then
            return
        end

        if self.state == 'growing' then
            self.update_growing(dt)
        else
            self.update_shrinking(dt)
        end
    end

   -- start animation:
    self.play = function ()
        self.running = true
    end

    -- stop animation:
    self.stop = function ()
        self.running = false
    end

    -- completion callback:
    self.oncomplete = function ()
    end

    self.init()
    return self
end


-- A "growing and fading out" animation for disappearing tiles:
function TilesDisappearing ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0

        -- constant:
        self.grow_speed = 100
        self.alpha_min = 0
        self.alpha_speed = 125
    end

    -- reset the animation settings:
    self.reset = function ()
        self.init()
    end

    -- update the animation logic:
    self.update = function (dt)
        if not self.running then
            return
        end

        self.alpha = math.max(self.alpha - (self.alpha_speed * dt), self.alpha_min)
        self.size = self.size + (self.grow_speed * dt)

        if self.alpha == self.alpha_min then
            self.running = false
            self.finished = true
            self.oncomplete()
        end
    end

   -- start animation:
    self.play = function ()
        self.running = true
    end

    -- stop animation:
    self.stop = function ()
        self.running = false
    end

    -- completion callback:
    self.oncomplete = function ()
    end

    self.init()
    return self
end


-- A growing animation:
function TilesGrowing (size_max)
    local self = {}

    -- initialization:
    self.init = function ()
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0

        self.size_max = 0
        self.speed = 0
    end

    -- reset the animation settings:
    self.reset = function (size_max)
        self.init()

        self.size_max = size_max
        self.speed = size_max
    end

    -- update the animation logic:
    self.update = function (dt)
        if not self.running then
            return
        end

        self.size = math.min(self.size + (self.speed * dt), self.size_max)

        if self.size == self.size_max then
            self.running = false
            self.finished = true
            self.oncomplete()
        end
    end

    -- start animation:
    self.play = function ()
        self.running = true
    end

    -- stop animation:
    self.stop = function ()
        self.running = false
    end

    -- completion callback:
    self.oncomplete = function ()
    end

    self.init()
    return self
end


-- A moving animation in a single direction (horizontal or vertical)
-- for tiles that are moving towards a target:
function TilesMoving ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0

        self.distance = 0
        self.direction = nil
        self.moved = 0
        self.speed = 0
    end

    -- reset the animation settings:
    self.reset = function (distance, direction)
        self.init()

        self.distance = distance
        self.direction = direction
        self.speed = distance * 3.5
    end

    -- update the animation logic:
    self.update = function (dt)
        if not self.running then
            return
        end

        self.offset_x = self.offset_x + (self.direction.X * (self.speed * dt))
        self.offset_y = self.offset_y + (self.direction.Y * (self.speed * dt))

        self.moved = math.abs(self.offset_x) + math.abs(self.offset_y)

        if self.moved >= self.distance then
            self.offset_x = self.direction.X * self.distance
            self.offset_y = self.direction.Y * self.distance

            self.moved = self.distance

            self.running = false
            self.finished = true
            self.oncomplete()
        end
    end

    -- start animation:
    self.play = function ()
        self.running = true
    end

    -- stop animation:
    self.stop = function ()
        self.running = false
    end

    -- completion callback:
    self.oncomplete = function ()
    end

    self.init()
    return self
end


-- Create a new grid:
function Grid()
    local self = {}

    -- initialization:
    self.init = function ()
        self.tiles = Array2d(GRID_TILE_WIDTH, GRID_TILE_HEIGHT)
        self.tiles_animation = nil

        self.appearing = TilesAppearing()
        self.disappearing = TilesDisappearing()
        self.growing = TilesGrowing()
        self.moving = TilesMoving()

        self.appearing.oncomplete = self.appearing_completed
        self.disappearing.oncomplete = self.disappearing_completed
        self.growing.oncomplete = self.growing_completed
        self.moving.oncomplete = self.moving_completed
    end

    -- adding tiles:

    -- add a random colored tile in a random position in the grid
    -- using a set of possible colors:
    self.add_random_tile = function (colors)
        local x, y = self.tiles.nth_random_nil()

        if x ~= nil and y ~= nil then
            local tile = RandomTile(colors)
            self.tiles.set(x, y, tile)

            tile.animated = true

            self.tiles_animation = self.appearing
            self.appearing.reset()
            self.appearing.play()
        end
    end

    -- add N random tiles:
    self.add_random_tiles = function (count, colors)
        for i = 1, count do
            self.add_random_tile(colors)
        end
    end

    -- add random tiles to the grid until a certain percentage is filled:
    self.add_random_tiles_filling = function (percentage, colors)
        local total = self.tiles.width * self.tiles.height

        local used = self.tiles.count_not_nil()
        local required = math.floor(percentage * (total / 100))

        while used < required do
            self.add_random_tile(colors)
            used = used + 1
        end
    end

    -- drawing:

    -- draw the background squares:
    self.draw_background = function ()
        local offset = (TILE_SIZE_BIG - TILE_SIZE_SMALL) / 2

        for x, y, tile in self.tiles.iter() do
            local screen_x = GRID_X + ((x - 1) * TILE_SIZE_BIG) + offset
            local screen_y = GRID_Y + ((y - 1) * TILE_SIZE_BIG) + offset

            draw_square(screen_x, screen_y, TILE_SIZE_SMALL, BACKGROUND_TILE_COLOR)
        end
    end

    -- draw a tile in the (x, y) grid coordinates:
    self.draw_tile = function (x, y, tile)
        local R = tile.color.R
        local G = tile.color.G
        local B = tile.color.B

        -- default drawing values:
        local alpha = 255
        local size = TILE_SIZE_SMALL
        local offset_x = 0
        local offset_y = 0

        -- apply animation values:
        if tile.animated then
            alpha = alpha * (self.tiles_animation.alpha / 100)
            size = size * (self.tiles_animation.size / 100)
            offset_x = offset_x + self.tiles_animation.offset_x
            offset_y = offset_y + self.tiles_animation.offset_y
        end

        -- calculate base screen coordinates:
        local screen_x = GRID_X + ((x - 1) * TILE_SIZE_BIG)
        local screen_y = GRID_Y + ((y - 1) * TILE_SIZE_BIG)

        -- add animation size and offset:
        screen_x = screen_x + ((TILE_SIZE_BIG - size) / 2) + offset_x
        screen_y = screen_y + ((TILE_SIZE_BIG - size) / 2) + offset_y

        draw_square(screen_x, screen_y, size, { R, G, B, alpha })
    end

    -- draw static tiles:
    self.draw_static_tiles = function()
        for x, y, tile in self.tiles.iter_not_nil() do
            if not tile.animated then
                self.draw_tile(x, y, tile)
            end
        end
    end

    -- draw the current animation tiles:
    self.draw_animated_tiles = function ()
        for x, y, tile in self.tiles.iter_not_nil() do
            if tile.animated then
                self.draw_tile(x, y, tile)
            end
        end
    end

    -- draw the grid:
    self.draw = function ()
        self.draw_background()
        self.draw_static_tiles()

        if self.tiles_animation ~= nil then
            self.draw_animated_tiles()
        end
    end

    -- updating:

    -- update the grid logic:
    self.update = function (dt)
        if self.tiles_animation ~= nil then
            self.tiles_animation.update(dt)
        end
    end

    -- remove all the animations:
    self.remove_animations = function ()
        for x, y, tile in self.tiles.iter_not_nil() do
            tile.animated = false
        end

        self.tiles_animation = nil
    end

    -- update logic after new tiles appeared:
    self.appearing_completed = function ()
        self.remove_animations()
    end

    -- update logic after tiles disappeared:
    self.disappearing_completed = function ()
        self.remove_animations()

        -- add new tiles:
    end

    -- update logic after tiles growth to the big size:
    self.growing_completed = function ()
        self.remove_animations()
    end

    -- update logic after tiles moved:
    self.moving_completed = function ()
        local distance_x = self.moving.direction.X * (self.moving.distance / TILE_SIZE_BIG)
        local distance_y = self.moving.direction.Y * (self.moving.distance / TILE_SIZE_BIG)

        -- collect the tiles that have been moved
        -- remove them from the grid and calculate their new position:
        local tiles = {}

        for x, y, tile in self.tiles.iter_not_nil() do
            if tile.animated then
                self.tiles.set(x, y, nil)
                table.insert(tiles, { x = x + distance_x, y = y + distance_y, tile = tile })
            end
        end

        -- put them in their new position:
        for index, tile in ipairs(tiles) do
            self.tiles.set(tile.x, tile.y, tile.tile)
        end

        self.remove_animations()
    end

    -- input:

    -- get the (x, y) coordinates for the tile under the mouse cursor:
    self.mouse_tile = function (mouse_x, mouse_y)
        local x = math.floor((mouse_x - GRID_X) / TILE_SIZE_BIG) + 1
        local y = math.floor((mouse_y - GRID_Y) / TILE_SIZE_BIG) + 1

        return x, y, self.tiles.get(x, y)
    end

    -- handle input:
    self.mousepressed = function (mouse_x, mouse_y, button)
        -- no move during animations:
        if self.tiles_animation ~= nil then
            return
        end

        local x, y, tile = self.mouse_tile(mouse_x, mouse_y)

        -- no tile or not movable:
        if tile == nil or tile.big then
            return
        end

        local direction = MOUSE_DIRECTIONS[button]

        -- unknown direction/mouse button:
        if direction == nil then
            return
        end

        local movement = self.tiles.count_nil_direction(x, y, direction)
        local distance = movement * TILE_SIZE_BIG

        -- don't move 0 pixels:
        if distance == 0 then
            return
        end

        self.tiles_animation = self.moving
        self.moving.reset(distance, direction)
        self.moving.play()

        tile.animated = true
    end

    self.init()
    return self
end

