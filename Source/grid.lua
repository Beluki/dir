
-- dir.
-- A simple, minimalistic puzzle game.


require 'array2d'
require 'constant'
require 'tile'
require 'tween'
require 'util'


-- Create a new grid:
function Grid()
    local self = {}

    self.tiles = Array2d(GRID_TILE_WIDTH, GRID_TILE_HEIGHT)
    self.tween = nil

    self.appearing = TweenAppearing()
    self.disappearing = TweenDisappearing()
    self.growing = TweenGrowing()
    self.moving = TweenMoving()

    -- adding tiles:

    -- add a random colored tile in a random position in the grid
    -- using a set of possible colors:
    self.add_random_tile = function (colors)
        local x, y = self.tiles.nth_random_nil()

        if x ~= nil and y ~= nil then
            local tile = RandomTile(colors)
            self.tiles.set(x, y, tile)

            tile.animated = true

            self.tween = self.appearing
            self.tween.reset()
            self.tween.play()
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
            local screen_x = offset + GRID_X + ((x - 1) * TILE_SIZE_BIG)
            local screen_y = offset + GRID_Y + ((y - 1) * TILE_SIZE_BIG)

            draw_square(screen_x, screen_y, TILE_SIZE_SMALL, BACKGROUND_TILE_COLOR)
        end
    end

    -- draw tiles:
    self.draw_tween_tiles = function ()
        for x, y, tile in self.tiles.iter() do
            if tile ~= nil and tile.animated then
                local R = tile.color.R
                local G = tile.color.G
                local B = tile.color.B

                -- default:
                local alpha = 255
                local size = TILE_SIZE_SMALL
                local offset_x = 0
                local offset_y = 0

                -- apply animation values:
                alpha = alpha * (self.tween.alpha / 100)
                size = size * (self.tween.size / 100)
                offset_x = offset_x + self.tween.offset_x
                offset_y = offset_y + self.tween.offset_y

                -- calculate base screen coordinates:
                local screen_x = GRID_X + ((x - 1) * TILE_SIZE_BIG)
                local screen_y = GRID_Y + ((y - 1) * TILE_SIZE_BIG)

                -- add animation size and offset:
                screen_x = screen_x + ((TILE_SIZE_BIG - size) / 2) + offset_x
                screen_y = screen_y + ((TILE_SIZE_BIG - size) / 2) + offset_y

                draw_square(screen_x, screen_y, size, { R, G, B, alpha })
            end
        end
    end

    -- draw the grid:
    self.draw = function ()
        self.draw_background()
        --self.draw_tiles(self.draw_static_tile_options)

        if self.tween then
            self.draw_tween_tiles()
        end
    end

    -- update:
    self.update = function (dt)
        if self.tween then
            self.tween.update(dt)
        end
    end

    return self
end

