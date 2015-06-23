
-- dir.
-- A simple, minimalistic puzzle game.


require 'lib/array2d'
require 'lib/love2d'


-- Grid animations:

-- There are four animations:
-- Tiles appearing, disappearing, growing or moving.

-- The implementations are tween-like and work with percentages.
-- The idea is to keep animation logic separated from the grid
-- and independent enough to be easy to understand in isolation.

-- One of them (or none) is active at any point during the gameplay
-- so there is a reset() method to reuse an animation with different
-- values, instead of creating a new object each time.

-- The animations expose the following properties, which are used
-- by the grid to determine how to draw each animated tile:

-- .size        -- size percentage
-- .alpha       -- alpha percentage
-- .offset_x    -- horizontal position (in tiles)
-- .offset_y    -- vertical position (in tiles)

-- As well as:

-- .finished    -- whether the animation has completed
-- .running     -- whether the animation is being updated (or paused)


-- A "snap into place" animation for appearing tiles:
local function TilesAppearing ()
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
        self.grow_max = 125
        self.grow_speed = 375

        self.shrink_min = 100
        self.shrink_speed = 150

        self.alpha_max = 100
        self.alpha_speed = self.grow_speed * 2.5
    end

    -- reset the animation settings:
    self.reset = function ()
        self.running = false
        self.finished = false

        self.size = 0
        self.alpha = 0
        self.offset_x = 0
        self.offset_y = 0

        self.state = 'growing'
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
        if self.running then
            if self.state == 'growing' then
                self.update_growing(dt)
            else
                self.update_shrinking(dt)
            end
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
local function TilesDisappearing ()
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
        self.grow_speed = 75
        self.alpha_min = 0
        self.alpha_speed = 250
    end

    -- reset the animation settings:
    self.reset = function ()
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0
    end

    -- update the animation logic:
    self.update = function (dt)
        if self.running then
            self.alpha = math.max(self.alpha - (self.alpha_speed * dt), self.alpha_min)
            self.size = self.size + (self.grow_speed * dt)

            if self.alpha == self.alpha_min then
                self.running = false
                self.finished = true
                self.oncomplete()
            end
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


-- A growing animation for tiles matching their neighbours:
local function TilesGrowing ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0

        -- values provided on reset():
        self.grow_max = nil
        self.grow_speed = nil
    end

    -- reset the animation settings:
    self.reset = function (grow_max)
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0

        self.grow_max = grow_max
        self.grow_speed = grow_max * 3
    end

    -- update the animation logic:
    self.update = function (dt)
        if self.running then
            self.size = math.min(self.size + (self.grow_speed * dt), self.grow_max)

            if self.size == self.grow_max then
                self.running = false
                self.finished = true
                self.oncomplete()
            end
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
local function TilesMoving ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0

        self.moved = 0

        -- values provided on reset():
        self.distance = 0
        self.direction = nil
        self.speed = 0
    end

    -- reset the animation settings:
    self.reset = function (distance, direction)
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0

        self.moved = 0

        self.distance = distance
        self.direction = direction
        self.speed = distance * 3.5
    end

    -- update the animation logic:
    self.update = function (dt)
        if self.running then
            self.offset_x = self.offset_x + (self.direction.x * self.speed * dt)
            self.offset_y = self.offset_y + (self.direction.y * self.speed * dt)

            self.moved = math.abs(self.offset_x) + math.abs(self.offset_y)

            if self.moved >= self.distance then
                self.offset_x = self.direction.x * self.distance
                self.offset_y = self.direction.y * self.distance

                self.moved = self.distance

                self.running = false
                self.finished = true
                self.oncomplete()
            end
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


-- All the tiles have three properties:
--   .color is an index into the current theme colors.
--   .big determines whether the tile has matched neighbour tiles.
--   .animated is true when the tile is subject to the current grid animation.

-- Create a new tile:
local function Tile (color)
    local self = {}

    -- initialization:
    self.init = function (color)
        self.color = color
        self.big = false
        self.animated = false
    end

    self.init(color)
    return self
end


-- This is the grid where gameplay takes place.
-- It cares about animations, calling game.state to handle
-- scoring and leveling instead.

-- Create a new grid:
function Grid (game)
    local self = {}

    -- initialization:
    self.init = function (game)
        self.game = game

        self.tiles = Array2d(game.grid_width, game.grid_height)
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

    -- restart the grid:
    self.restart = function ()
        self.tiles.clear()
        self.tiles_animation = nil
    end

    -- marking/unmarking tiles for animation:

    -- set .animated = true for all the big tiles
    -- and return the count:
    self.mark_big_tiles = function ()
        local count = 0

        for x, y, tile in self.tiles.iter_not_nil() do
            if tile.big then
                tile.animated = true
                count = count + 1
            end
        end

        return count
    end

    -- set .animated = true for all the neighbours of (x, y)
    -- that match a color and return the count:
    self.mark_neighbour_matches = function (x, y, color)
        local count = 0

        for tile_x, tile_y, tile in self.tiles.iter_neighbours_not_nil(x, y) do
            if tile.color == color then
                if not tile.big then
                    tile.animated = true
                end

                count = count + 1
            end
        end

        return count
    end

    -- concise animation methods:
    -- (those also make sure reset() is called)

    -- start the appearing animation:
    -- (target tiles are expected to be marked with tile.animated = true)
    self.start_appearing = function ()
        self.tiles_animation = self.appearing
        self.appearing.reset()
        self.appearing.play()
    end

    -- start the disappearing animation:
    -- (marks tiles as needed)
    self.start_disappearing = function ()
        self.tiles_animation = self.disappearing

        -- avoid the animation when no big tiles have been marked:
        -- (makes gameplay more fluid)
        if self.mark_big_tiles() > 0 then
            self.disappearing.reset()
            self.disappearing.play()
        else
            self.disappearing_completed()
        end
    end

    -- start the growing animation:
    -- (target tiles are expected to be marked with tile.animated = true)
    self.start_growing = function ()
        self.tiles_animation = self.growing
        self.growing.reset(TILE_SIZE_SMALL_GROW_PERCENTAGE)
        self.growing.play()
    end

    -- start the moving animation:
    -- (target tiles are expected to be marked with tile.animated = true)
    self.start_moving = function (distance, direction)
        self.tiles_animation = self.moving
        self.moving.reset(distance, direction)
        self.moving.play()
    end

    -- adding new tiles:

    -- add a random colored tile in a random position:
    self.add_random_tile = function (colors)
        local x, y = self.tiles.nth_random_nil()

        if x and y then
            local color = math.random(colors)
            local tile = Tile(color)

            self.tiles.set(x, y, tile)

            tile.animated = true
            self.start_appearing()
        end
    end

    -- add N random tiles in random positions:
    self.add_random_tiles = function (colors, count)
        for i = 1, count do
            self.add_random_tile(colors)
        end
    end

    -- add random tiles until a percentage of the entire grid is filled:
    self.add_random_tiles_filling = function (colors, percentage)
        local total = self.tiles.width * self.tiles.height

        local used = self.tiles.count_not_nil()
        local required = math.floor(percentage * (total / 100))

        while used < required do
            self.add_random_tile(colors)
            used = used + 1
        end
    end

    -- checking the grid state:

    -- determine whether there are no free positions:
    self.is_full = function ()
        return self.tiles.count_nil() == 0
    end

    -- determine whether there are no tiles:
    self.is_empty = function ()
        return self.tiles.count_not_nil() == 0
    end

    -- determine whether there are no moves available:
    self.is_deadlocked = function ()
        for x, y, tile in self.tiles.iter_not_nil() do
            if not tile.big then
                for neighbour_x, neighbour_y, neighbour_tile in self.tiles.iter_neighbours(x, y) do
                    if neighbour_tile == nil then
                        return false
                    end
                end
            end
        end

        return true
    end

    -- drawing:

    -- draw the background squares:
    self.draw_background = function ()
        local screen = self.game.screen
        local color = self.game.theme.background_tile

        local offset = (screen.tile_size - screen.tile_size_small) / 2

        for x, y, tile in self.tiles.iter() do
            local screen_x = screen.grid_x + ((x - 1) * screen.tile_size) + offset
            local screen_y = screen.grid_y + ((y - 1) * screen.tile_size) + offset

            love2d.draw_square(screen_x, screen_y, screen.tile_size_small, color)
        end
    end

    -- draw a tile in the (x, y) coordinates:
    self.draw_tile = function (x, y, tile)
        local screen = self.game.screen
        local color = self.game.theme.tiles[tile.color]

        -- default drawing values (non-animated tiles):
        local alpha = 255
        local size = tile.big and screen.tile_size or screen.tile_size_small
        local offset_x = 0
        local offset_y = 0

        -- current animation values:
        if tile.animated then
            alpha = alpha * (self.tiles_animation.alpha / 100)
            size = size * (self.tiles_animation.size / 100)
            offset_x = offset_x + (self.tiles_animation.offset_x * screen.tile_size)
            offset_y = offset_y + (self.tiles_animation.offset_y * screen.tile_size)
        end

        -- calculate base screen coordinates:
        local screen_x = screen.grid_x + ((x - 1) * screen.tile_size)
        local screen_y = screen.grid_y + ((y - 1) * screen.tile_size)

        -- add animation size and offset:
        screen_x = screen_x + ((screen.tile_size - size) / 2) + offset_x
        screen_y = screen_y + ((screen.tile_size - size) / 2) + offset_y

        love2d.draw_square(screen_x, screen_y, size, { color.R, color.G, color.B, alpha })
    end

    -- draw static tiles:
    self.draw_static_tiles = function ()
        for x, y, tile in self.tiles.iter_not_nil() do
            if not tile.animated then
                self.draw_tile(x, y, tile)
            end
        end
    end

    -- draw the animation tiles:
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

    -- update logic after new tiles appeared:
    self.appearing_completed = function ()
        self.tiles_animation = nil

        local tile_count = 0

        for x, y, tile in self.tiles.iter_not_nil() do
            if tile.animated then
                tile.animated = false
                tile_count = tile_count + 1
            end
        end

        self.game.state.appearing_completed(tile_count)
    end

    -- update logic after tiles disappeared:
    self.disappearing_completed = function ()
        self.tiles_animation = nil

        local tile_count = 0

        for x, y, tile in self.tiles.iter_not_nil() do
            if tile.animated then
                tile.animated = false
                tile_count = tile_count + 1
                self.tiles.set(x, y, nil)
            end
        end

        self.game.state.disappearing_completed(tile_count)
    end

    -- update logic after tiles matched neighbours:
    self.growing_completed = function ()
        self.tiles_animation = nil

        local tile_count = 0

        for x, y, tile in self.tiles.iter_not_nil() do
            if tile.animated then
                tile.animated = false
                tile_count = tile_count + 1
                tile.big = true
            end
        end

        -- update state before chaining other animations:
        self.game.state.growing_completed(tile_count)

        -- no moves available after growing, remove big tiles:
        if self.is_deadlocked() then
            self.start_disappearing()
        end
    end

    -- update logic after a tile has moved:
    self.moving_completed = function ()
        self.tiles_animation = nil

        local old_x, old_y, moved

        -- find the tile that has been moved:
        for x, y, tile in self.tiles.iter_not_nil() do
            if tile.animated then
                old_x = x
                old_y = y
                moved = tile
                break
            end
        end

        -- update position:
        local new_x = old_x + (self.moving.direction.x * self.moving.distance)
        local new_y = old_y + (self.moving.direction.y * self.moving.distance)

        self.tiles.set(old_x, old_y, nil)
        self.tiles.set(new_x, new_y, moved)

        -- update state before chaining other animations:
        self.game.state.moving_completed()

        -- when there are matches: start growing, otherwise: make big tiles disappear:
        local matches = self.mark_neighbour_matches(new_x, new_y, moved.color)

        if matches > 0 then
            moved.animated = true
            self.start_growing()
        else
            moved.animated = false
            self.start_disappearing()
        end
    end

    -- input:

    -- get (x, y, tile) for the tile at the given point:
    self.tile_at_point = function (x, y)
        local screen = self.game.screen

        local tile_x = math.floor((x - screen.grid_x) / screen.tile_size) + 1
        local tile_y = math.floor((y - screen.grid_y) / screen.tile_size) + 1

        return tile_x, tile_y, self.tiles.get(tile_x, tile_y)
    end

    -- handle input:
    self.mousepressed = function (mouse_x, mouse_y, button)
        -- no move during animations:
        if self.tiles_animation then
            return
        end

        local x, y, tile = self.tile_at_point(mouse_x, mouse_y)

        -- no tile or not movable:
        if tile == nil or tile.big then
            return
        end

        local direction = MOUSE_DIRECTIONS[button]

        -- unknown direction/mouse button:
        if direction == nil then
            return
        end

        local distance = self.tiles.count_nil_direction(x, y, direction)

        -- don't move 0 tiles:
        if distance == 0 then
            return
        end

        tile.animated = true
        self.start_moving(distance, direction)
    end


    self.init(game)
    return self
end

