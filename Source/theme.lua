
-- dir.
-- A simple, minimalistic puzzle game.


require 'util'


function ThemeLight ()
    self = {}

    -- initialization:
    self.init = function ()
        self.name = "light"
        self.background = { 255, 255, 255 }
        self.background_tile = { 240, 240, 240 }
        self.hud_font = { 200, 200, 200 }

        self.tiles = {
            { 255,  50,  50 }, -- red
            {  35, 217,  82 }, -- green
            {  22, 127, 252 }, -- blue
            { 255, 221,  47 }, -- yellow
            { 255,  89, 220 }, -- purple
        }
    end

    self.init()
    return self
end


function ThemeDark ()
    self = {}

    -- initialization:
    self.init = function ()
        self.name = "dark"
        self.background = { 0, 0, 0 }
        self.background_tile = { 10, 10, 10 }
        self.hud_font = { 100, 100, 100 }

        self.tiles = {
            { 255,  24, 115 }, -- pink
            {  13, 255, 242 }, -- cyan
            { 255, 205,  25 }, -- yellow
            { 167,  87, 171 }, -- violet
            {  24, 255,  30 }, -- green
        }
    end

    self.init()
    return self
end

