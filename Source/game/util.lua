
-- dir.
-- A simple, minimalistic puzzle game.


-- Determine if a point is inside a rectangle:
function point_inside_rect (x, y, rect_x, rect_y, rect_width, rect_height)
    return (x >= rect_x)
       and (y >= rect_y)
       and (x <= rect_x + rect_width)
       and (y <= rect_y + rect_height)
end


-- Sort an array in-place randomly:
function shuffle (array)
    local length = #array
    local random = math.random

    for index1 = 1, length do
        local index2 = random(length)

        array[index1], array[index2] = array[index2], array[index1]
    end
end

-- Convert a number to a string, using a thousands separator:
function separate_thousands (number)
    local s = tostring(number)

    if s:len() > 3 then
        s = s:reverse()
        s = s:gsub("(%d%d%d)", "%1.")
        s = s:reverse()

        if s:sub(1, 1) == "." then
            s = s:sub(2)
        end
    end

    return s
end

