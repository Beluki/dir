
-- dir.
-- A simple, minimalistic puzzle game.


-- Draw a filled square with a specific color:
function draw_square (x, y, size, color)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, size, size)
end

-- Change window mode between windowed and fullscreen:
function toggle_fullscreen ()
    love.window.setFullscreen(not love.window.getFullscreen())
end

-- Determine if a point is inside a rectangle:
function point_inside_rect (x, y, rect_x, rect_y, rect_width, rect_height)
    return (x >= rect_x)
       and (y >= rect_y)
       and (x <= rect_x + rect_width)
       and (y <= rect_y + rect_height)
end

