
-- dir.
-- A simple, minimalistic puzzle game.


-- Wrappers over the Love2D libraries for the (tiny) feature subset used in dir.
-- When Love2D changes it should be possible to replace the implementations
-- with new ones without touching most of the game source.


love2d = {}


-- Drawing:

-- Draw a square:
love2d.draw_square = function (x, y, size, color)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, size, size)
end

-- Draw text:
love2d.draw_text = function (text, x, y, color, font)
    love.graphics.setColor(color)
    love.graphics.setFont(font)
    love.graphics.print(text, x, y)
end


-- Events:

-- Quit the game:
love2d.event_quit = function ()
    love.event.quit()
end


-- Graphics:

-- Load a font:
love2d.graphics_new_font = function (path, size)
    return love.graphics.newFont(path, size)
end

-- Change the background color:
love2d.graphics_set_background_color = function (color)
    love.graphics.setBackgroundColor(color)
end


-- Windows:

-- Get the current window width:
love2d.window_width = function ()
    return love.window.getWidth()
end

-- Get the current window height:
love2d.window_height = function ()
    return love.window.getHeight()
end

-- Toggle between full screen and windowed:
love2d.window_toggle_fullscreen = function ()
    love.window.setFullscreen(not love.window.getFullscreen())
end

-- Determine whether we are actually in full screen mode:
love2d.window_is_fullscreen = function ()
    return love.window.getFullscreen()
end

