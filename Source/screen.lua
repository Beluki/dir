
-- dir.
-- A simple, minimalistic puzzle game.


require 'constant'
require 'util'


-- Since all the graphics are vector-based and the animations work with percentages
-- the game is resolution independent. The Screen object keeps track of all
-- the elements size and position on the screen.

-- This is simpler than each component having a .resize method, because the element
-- positions are dependent on each other sizes.


-- Create a new screen object:
function Screen (width, height)
    local self = {}

    -- initialization:
    self.init = function (width, height)
        self.tile_size = 0
        self.tile_size_small = 0

        self.hud_tile_height = 1
        self.hud_font_size = 0
        self.hud_width = 0
        self.hud_height = 0
        self.hud_x = 0
        self.hud_y = 0

        self.grid_tile_width = width
        self.grid_tile_height = height
        self.grid_width = 0
        self.grid_height = 0
        self.grid_x = 0
        self.grid_y = 0
    end

    -- determine if a point is inside the hud:
    self.point_inside_hud = function (x, y)
        return point_inside_rect(x, y, self.hud_x, self.hud_y, self.hud_width, self.hud_height)
    end

    -- determine if a point is inside the grid:
    self.point_inside_grid = function (x, y)
        return point_inside_rect(x, y, self.grid_x, self.grid_y, self.grid_width, self.grid_height)
    end

    -- recalculate sizes and positions on a window resize:
    self.resize = function (width, height)

        -- calculate the minimum tile size that fills the window width or height:
        local width_max_tile = width / self.grid_tile_width
        local height_max_tile = height / (self.hud_tile_height + self.grid_tile_height)

        self.tile_size = math.min(width_max_tile, height_max_tile)
        self.tile_size_small = self.tile_size * (TILE_SIZE_SMALL_PERCENTAGE / 100)

        -- the hud is one tile height and as wide as the grid:
        self.hud_tile_height = 1
        self.hud_width = self.tile_size * self.grid_tile_width
        self.hud_height = self.tile_size
        self.hud_font_size = self.tile_size
        self.hud_x = 0
        self.hud_y = 0

        -- the grid position is centered below the hud:
        self.grid_width = self.tile_size * self.grid_tile_width
        self.grid_height = self.tile_size * self.grid_tile_height
        self.grid_x = (width / 2) - (self.grid_width / 2)
        self.grid_y = self.hud_height + ((height - self.hud_height) / 2) - (self.grid_height / 2)
    end

    self.init(width, height)
    return self
end

