
-- dir.
-- A simple, minimalistic puzzle game.


-- Wrappers over the Love2D libraries for the feature subset needed in dir.
-- When Love changes, it should be possible to replace the implementations
-- with new ones, without touching anything else in the game source.


-- Drawing:

-- Draw a square:
function draw_square (x, y, size, color)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, size, size)
end

-- Draw text:
function draw_text (text, x, y, color, font)
    love.graphics.setColor(color)
    love.graphics.setFont(font)
    love.graphics.print(text, x, y)
end

