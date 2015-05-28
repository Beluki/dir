
-- Meve.
-- A simple, minimalistic puzzle game.


-- Draw a square with a specific color:
function draw_square (x, y, size, color)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, size, size)
end


-- Clamp a value between min/max (inclusive):
function clamp(value, min, max)
    if value < min then
        return min
    end

    if value > max then
        return max
    end

    return value
end

