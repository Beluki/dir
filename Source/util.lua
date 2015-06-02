
-- dir.
-- A simple, minimalistic puzzle game.


-- Draw a square with a specific color:
function draw_square (x, y, size, color)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, size, size)
end

-- Clamp a value between min/max (inclusive):
function clamp (value, min, max)
    if value < min then
        return min
    end

    if value > max then
        return max
    end

    return value
end

-- Determine if a point is inside a rectangle:
function point_inside_rect (x, y, rect_x, rect_y, rect_width, rect_height)
    return (x >= rect_x)
       and (y >= rect_y)
       and (y <= rect_y + rect_height)
       and (x <= rect_x + rect_width)
end

