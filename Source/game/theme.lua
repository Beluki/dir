
-- dir.
-- A simple, minimalistic puzzle game.


require 'game/util'


-- Themes:

local theme1 = {
    background = { 255, 255, 255 },
    background_tile = { 235, 235, 235 },
    hud_font = { 200, 200, 200 },
    menu_font = { 200, 200, 200 },

    tiles = {
        { R = 255, G =  70, B =  70 }, -- red
        { R = 150, G = 200, B =   0 }, -- green
        { R =  50, G = 180, B = 230 }, -- cyan
        { R = 255, G = 180, B =  50 }, -- orange
        { R = 170, G = 100, B = 205 }, -- purple
    }
}

local theme2 = {
    background = { 20, 20, 20 },
    background_tile = { 35, 35, 35 },
    hud_font = { 160, 160, 160 },
    menu_font = { 160, 160, 160 },

    tiles = {
        { R = 255, G =  70, B =  70 }, -- red
        { R = 150, G = 200, B =   0 }, -- green
        { R =  50, G = 180, B = 230 }, -- cyan
        { R = 255, G = 180, B =  30 }, -- orange
        { R = 170, G = 100, B = 205 }, -- purple
    }
}

local theme3 = {
    background = { 245, 240, 236 },
    background_tile = { 225, 220, 210 },
    hud_font = { 195, 190, 186 },
    menu_font = { 195, 190, 186 },

    tiles = {
        { R = 255, G =  50, B = 102 }, -- red
        { R = 136, G = 225, B =  58 }, -- green
        { R = 125, G = 129, B = 192 }, -- steel blue
        { R = 255, G = 162, B =  46 }, -- orange
        { R = 250, G = 215, B =  25 }, -- yellow
    }
}

local themes = { theme1, theme2, theme3 }


-- Theme manager:

function Theme (game)
    local self = {}

    -- initialization:
    self.init = function (game)
        self.background = nil
        self.background_tile = nil
        self.hud_font = nil
        self.menu_font = nil
        self.tiles = nil

        self.theme_index = 1
        self.load_theme(self.theme_index)
    end

    -- on restart, shuffle the current theme tile colors:
    self.restart = function ()
        shuffle(self.tiles)
    end

    -- load a given theme:
    self.load_theme = function (index)
        local theme = themes[index]

        self.background = theme.background
        self.background_tile = theme.background_tile
        self.hud_font = theme.hud_font
        self.menu_font = theme.menu_font
        self.tiles = theme.tiles

        self.theme_index = index
    end

    -- load the next theme to the current one:
    self.load_next_theme = function ()
        local index = self.theme_index + 1

        if index > #themes then
            index = 1
        end

        self.load_theme(index)
    end

    self.init()
    return self
end

