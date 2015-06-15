
-- dir.
-- A simple, minimalistic puzzle game.


-- Determine if a point is inside a rectangle:
function point_inside_rect (x, y, rect_x, rect_y, rect_width, rect_height)
    return (x >= rect_x)
       and (y >= rect_y)
       and (x <= (rect_x + rect_width))
       and (y <= (rect_y + rect_height))
end


-- Change an array order:
function shuffle (array)
    local length = #array

    for index1 = 1, length do
        index2 = math.random(length)

        array[index1], array[index2] = array[index2], array[index1]
    end
end

