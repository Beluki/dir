
-- dir.
-- A simple, minimalistic puzzle game.


require 'util'


-- Since all the graphics are vector-based and the animations work with percentages
-- the game is resolution independent. The Screen object keeps track of all
-- the elements size and position on the screen.


-- Create a new screen object:
function Screen (grid_tile_width, grid_tile_height)
    local self = {}

    -- initialization:
    self.init = function (grid_tile_width, grid_tile_height)
        self.tile_size = 0
        self.tile_size_small = 0

        self.hud_tile_height = 1
        self.hud_width = 0
        self.hud_height = 0
        self.hud_x = 0
        self.hud_y = 0

        self.grid_tile_width = grid_tile_width
        self.grid_tile_height = grid_tile_height
        self.grid_width = 0
        self.grid_height = 0
        self.grid_x = 0
        self.grid_y = 0
    end

    -- determine if a given point is inside the grid:
    self.point_inside_grid = function (x, y)
        return point_inside_rect(x, y, self.grid_x, self.grid_y, self.grid_width, self.grid_height)
    end

    -- recalculate sizes and positions for a window resolution:
    self.update = function (width, height)

        -- calculate the minimum tile size that fills the window width or height:
        local width_max_tile = width / self.grid_tile_width
        local height_max_tile = height / (self.grid_tile_height + self.hud_tile_height)

        self.tile_size = math.min(width_max_tile, height_max_tile)
        self.tile_size_small = self.tile_size * (TILE_SIZE_SMALL_PERCENTAGE / 100)

        self.hud_width = self.tile_size * self.grid_tile_width
        self.hud_height = self.tile_size
        self.hud_x = 0
        self.hud_y = 0

        self.grid_width = self.tile_size * self.grid_tile_width
        self.grid_height = self.tile_size * self.grid_tile_height
        self.grid_x = (width / 2) - (self.grid_width / 2)
        self.grid_y = self.hud_height + ((height - self.hud_height) / 2) - (self.grid_height / 2)
    end

    self.init(grid_tile_width, grid_tile_height)
    return self
end

