
-- dir.
-- A simple, minimalistic puzzle game.


require 'util'


-- Since all the graphics are vector-based and the animations work with percentages
-- the game is resolution independent. The Screen object keeps track of all
-- the elements size and position.

-- This is simpler than each component having a .resize method, because the element
-- positions are dependent on each other.


-- Create a new screen object:
function Screen (game)
    local self = {}

    -- initialization:
    self.init = function (game)
        self.game = game

        self.tile_size = 0
        self.tile_size_small = 0

        self.hud_base_font_size = 0
        self.hud_width = 0
        self.hud_height = 0
        self.hud_x = 0
        self.hud_y = 0

        self.grid_tile_width = self.game.grid_width
        self.grid_tile_height = self.game.grid_height
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
    self.resize = function (window_width, window_height)
        -- hud size in tiles:
        local hud_tile_height = 1
        local hud_tile_width = window_width

        -- margin on the sides of the grid:
        local grid_margin_left = 0.10
        local grid_margin_right = 0.10
        local grid_margin_top = hud_tile_height
        local grid_margin_bottom = 0.10

        local grid_width_margin = grid_margin_left + grid_margin_right
        local grid_height_margin = grid_margin_top + grid_margin_bottom

        -- calculate the minimum tile size that can fill the width or height:
        local width_max_tile = window_width / (self.grid_tile_width + grid_width_margin)
        local height_max_tile = window_height / (self.grid_tile_height + grid_height_margin)

        self.tile_size = math.min(width_max_tile, height_max_tile)
        self.tile_size_small = self.tile_size * (TILE_SIZE_SMALL_PERCENTAGE / 100)

        self.hud_base_font_size = self.tile_size
        self.hud_width = window_width
        self.hud_height = self.tile_size

        self.grid_width = self.tile_size * self.grid_tile_width
        self.grid_height = self.tile_size * self.grid_tile_height

        -- hud at the top:
        self.hud_x = 0
        self.hud_y = 0

        -- grid centered below the hud:
        self.grid_x = (window_width / 2) - (self.grid_width / 2)
        self.grid_y = self.hud_height + ((window_height - self.hud_height) / 2) - (self.grid_height / 2)
    end

    self.init(game)
    return self
end

