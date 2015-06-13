
-- dir.
-- A simple, minimalistic puzzle game.


function ThemeLight (game)
    self = {}

    -- initialization:
    self.init = function (game)
        self.background = { 255, 255, 255 }
        self.background_tile = { 240, 240, 240 }
        self.hud_font = { 200, 200, 200 }

        self.tiles = {
            { R = 255, G =  50, B =  50 }, -- red
            { R =  35, G = 217, B =  82 }, -- green
            { R =  22, G = 127, B = 252 }, -- blue
            { R = 255, G = 221, B =  47 }, -- yellow
            { R = 255, G =  89, B = 220 }, -- purple
        }
    end

    self.init(game)
    return self
end


function ThemeDark (game)
    self = {}

    -- initialization:
    self.init = function (game)
        self.background = { 0, 0, 0 }
        self.background_tile = { 10, 10, 10 }
        self.hud_font = { 100, 100, 100 }

        self.tiles = {
            { R = 255, G =  24, B = 115 }, -- pink
            { R =  13, G = 255, B = 242 }, -- cyan
            { R = 255, G = 205, B =  25 }, -- yellow
            { R = 167, G =  87, B = 171 }, -- violet
            { R =  24, G = 255, B =  30 }, -- green
        }
    end

    self.init(game)
    return self
end

