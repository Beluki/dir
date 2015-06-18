
-- dir.
-- A simple, minimalistic puzzle game.


require 'game/util'


function ThemeLight (game)
    self = {}

    -- initialization:
    self.init = function (game)
        self.background = { 255, 255, 255 }
        self.background_tile = { 235, 235, 235 }
        self.hud_font = { 200, 200, 200 }

        self.tiles = {
            { R = 255, G =  70, B =  70 }, -- red
            { R = 150, G = 200, B =   0 }, -- green
            { R =  50, G = 180, B = 230 }, -- cyan
            { R = 255, G = 180, B =  50 }, -- orange
            { R = 170, G = 100, B = 205 }, -- purple
        }
    end

    -- shuffle the tile colors on restart:
    self.restart = function ()
        shuffle(self.tiles)
    end

    self.init(game)
    return self
end


function ThemeDark (game)
    self = {}

    -- initialization:
    self.init = function (game)
        self.background = { 20, 20, 20 }
        self.background_tile = { 35, 35, 35 }
        self.hud_font = { 160, 160, 160 }

        self.tiles = {
            { R = 255, G =  70, B =  70 }, -- red
            { R = 150, G = 200, B =   0 }, -- green
            { R =  50, G = 180, B = 230 }, -- cyan
            { R = 255, G = 180, B =  30 }, -- orange
            { R = 170, G = 100, B = 205 }, -- purple
        }
    end

    -- shuffle the tile colors on restart:
    self.restart = function ()
        shuffle(self.tiles)
    end

    self.init(game)
    return self
end

