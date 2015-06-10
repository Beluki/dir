
-- dir.
-- A simple, minimalistic puzzle game.


require 'lib/array2d'
require 'lib/love2d'

require 'grid_animation'
require 'tile'


-- This is the grid where gameplay takes place.
-- The implementation does not keep game state directly but uses an external object
-- so that scoring or combo values are easily modified.


-- Create a new grid:
function Grid (width, height, gamestate)
    local self = {}

    -- initialization:
    self.init = function (width, height, gamestate)
        self.tiles = Array2d(width, height)
        self.tiles_animation = nil

        self.appearing = GridTilesAppearing()
        self.disappearing = GridTilesDisappearing()
        self.growing = GridTilesGrowing()
        self.moving = GridTilesMoving()

        self.appearing.oncomplete = self.appearing_completed
        self.disappearing.oncomplete = self.disappearing_completed
        self.growing.oncomplete = self.growing_completed
        self.moving.oncomplete = self.moving_completed

        self.gamestate = gamestate
    end

    -- concise animation methods:

    -- start the appearing animation:
    -- (target tiles are expected to be marked with tile.animated = true)
    self.start_appearing = function ()
        self.tiles_animation = self.appearing
        self.appearing.reset()
        self.appearing.play()
    end

    -- start the disappearing animation:
    -- (target tiles are expected to be marked with tile.animated = true)
    self.start_disappearing = function ()
        self.tiles_animation = self.disappearing
        self.disappearing.reset()
        self.disappearing.play()
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

    -- marking tiles for animation:

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
    -- that match a given color and return the count:
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

    -- adding new tiles:

    -- add a random colored tile in a random position:
    self.add_random_tile = function ()
        local x, y = self.tiles.nth_random_nil()

        if x and y then
            local color = math.random(self.gamestate.colors)
            local tile = Tile(color)

            self.tiles.set(x, y, tile)

            tile.animated = true
            self.start_appearing()
        end
    end

    -- add N random tiles in random positions:
    self.add_random_tiles = function (count)
        for i = 1, count do
            self.add_random_tile()
        end
    end

    -- add random tiles until a certain grid percentage is filled:
    self.add_random_tiles_filling = function (percentage)
        local total = self.tiles.width * self.tiles.height

        local used = self.tiles.count_not_nil()
        local required = math.floor(percentage * (total / 100))

        while used < required do
            self.add_random_tile()
            used = used + 1
        end
    end

    -- checking the grid state:

    -- determine if the grid contains no tiles:
    self.is_empty = function ()
        return self.tiles.count_not_nil() == 0
    end

    -- determine if the grid is completely filled:
    self.is_full = function ()
        return self.tiles.count_nil() == 0
    end

    -- determine if there are moves available:
    self.is_deadlocked = function ()
        for x, y, tile in self.tiles.iter_not_nil() do
            if not tile.big then
                for neighbour_x, neighbour_y, neighbour in self.tiles.iter_neighbours(x, y) do
                    if neighbour == nil then
                        return false
                    end
                end
            end
        end

        return true
    end

    -- drawing:

    -- draw the background squares:
    self.draw_background = function (screen, theme)
        local offset = (screen.tile_size - screen.tile_size_small) / 2

        for x, y, tile in self.tiles.iter() do
            local screen_x = screen.grid_x + ((x - 1) * screen.tile_size) + offset
            local screen_y = screen.grid_y + ((y - 1) * screen.tile_size) + offset

            draw_square(screen_x, screen_y, screen.tile_size_small, theme.background_tile)
        end
    end

    -- draw a tile in the (x, y) grid coordinates:
    self.draw_tile = function (screen, theme, x, y, tile)
        local R, G, B = unpack(theme.tiles[tile.color])

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

        draw_square(screen_x, screen_y, size, { R, G, B, alpha })
    end

    -- draw static tiles:
    self.draw_static_tiles = function (screen, theme)
        for x, y, tile in self.tiles.iter_not_nil() do
            if not tile.animated then
                self.draw_tile(screen, theme, x, y, tile)
            end
        end
    end

    -- draw the animation tiles:
    self.draw_animated_tiles = function (screen, theme)
        for x, y, tile in self.tiles.iter_not_nil() do
            if tile.animated then
                self.draw_tile(screen, theme, x, y, tile)
            end
        end
    end

    -- draw the grid:
    self.draw = function (screen, theme)
        self.draw_background(screen, theme)
        self.draw_static_tiles(screen, theme)

        if self.tiles_animation then
            self.draw_animated_tiles(screen, theme)
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

        for x, y, tile in self.tiles.iter_not_nil() do
            tile.animated = false
        end
    end

    -- update logic after tiles disappeared:
    self.disappearing_completed = function ()
        self.tiles_animation = nil

        for x, y, tile in self.tiles.iter_not_nil() do
            if tile.animated then
                self.tiles.set(x, y, nil)
            end
        end

        self.gamestate.disappearing_completed(10)

        self.add_random_tiles(self.gamestate.tiles)
    end

    -- update logic after tiles matched neighbours:
    self.growing_completed = function ()
        self.tiles_animation = nil

        for x, y, tile in self.tiles.iter_not_nil() do
            if tile.animated then
                tile.animated = false
                tile.big = true
            end
        end

        if self.is_deadlocked() then
            self.mark_big_tiles()
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

        -- look for matches:
        local matches = self.mark_neighbour_matches(new_x, new_y, moved.color)

        if matches > 0 then
            -- match, animate the growing tiles, including the moved one:
            moved.animated = true
            self.start_growing()
        else
            -- no match, make the current matched tiles disappear:
            moved.animated = false

            -- avoid the animation when possible:
            if self.mark_big_tiles() > 0 then
                self.start_disappearing()
            else
                self.disappearing_completed()
            end
        end
    end

    -- input:

    -- get (x, y, tile) for the tile at the given point:
    self.tile_at_point = function (screen, x, y)
        local tile_x = math.floor((x - screen.grid_x) / screen.tile_size) + 1
        local tile_y = math.floor((y - screen.grid_y) / screen.tile_size) + 1

        return tile_x, tile_y, self.tiles.get(tile_x, tile_y)
    end

    -- handle input:
    self.mousepressed = function (screen, mouse_x, mouse_y, button)
        -- no move during animations:
        if self.tiles_animation ~= nil then
            return
        end

        local x, y, tile = self.tile_at_point(screen, mouse_x, mouse_y)

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

        -- don't move 0 pixels:
        if distance == 0 then
            return
        end

        tile.animated = true
        self.start_moving(distance, direction)
    end

    self.init(width, height, gamestate)
    return self
end

