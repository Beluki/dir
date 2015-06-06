
-- dir.
-- A simple, minimalistic puzzle game.


-- This is a small 2d array library used in the game grid.
-- It's reusable and standalone. It does not depend on other libraries.


-- Create a new two-dimensional array:
function Array2d(width, height)
    local self = {}

    -- initialization:
    self.init = function (width, height)
        self.cells = {}
        self.width = width
        self.height = height

        for x = 1, self.width do
            self.cells[x] = {}

            for y = 1, self.height do
                self.cells[x][y] = nil
            end
        end
    end

    -- get a cell value:
    self.get = function (x, y)
        return self.cells[x][y]
    end

    -- set a cell value:
    self.set = function (x, y, value)
        self.cells[x][y] = value
    end

    -- determine whether a coordinate is in the array bounds:
    self.contains = function (x, y)
        return (x >= 1) and (x <= self.width)
           and (y >= 1) and (y <= self.height)
    end

    -- traverse the array from top-left to bottom-right
    -- and return (x, y, cell) for each cell:
    self.iter = function ()
        local iterator = function ()
            for y = 1, self.height do
                for x = 1, self.width do
                    coroutine.yield(x, y, self.cells[x][y])
                end
            end
        end

        return coroutine.wrap(iterator)
    end

    -- iterate the array from top-left to bottom-right, row by row
    -- and return (x, y, value) for each not nil cell:
    self.iter_not_nil = function ()
        local iterator = function ()
            for x, y, cell in self.iter() do
                if cell ~= nil then
                    coroutine.yield(x, y, cell)
                end
            end
        end

        return coroutine.wrap(iterator)
    end

    -- iterate cells from a given starting
    -- point in the four cardinal directions:
    self.iter_directions = function (x, y)
        local directions = {
            { x =  0, y = -1 },
            { x =  1, y =  0 },
            { x =  0, y =  1 },
            { x = -1, y =  0 },
        }

        local iterator = function ()
            for index, direction in ipairs(directions) do
                local cell_x = x + direction.x
                local cell_y = y + direction.y

                if self.contains(cell_x, cell_y) then
                    coroutine.yield(cell_x, cell_y, self.cells[cell_x][cell_y])
                end
            end
        end

        return coroutine.wrap(iterator)
    end

    -- iterate not nil cells from a given starting
    -- point in the four cardinal directions:
    self.iter_directions_not_nil = function (x, y)
        local iterator = function ()
            for cell_x, cell_y, cell in self.iter_directions(x, y) do
                if cell ~= nil then
                    coroutine.yield(cell_x, cell_y, cell)
                end
            end
        end

        return coroutine.wrap(iterator)
    end

    -- set all the cells in the array to a given value:
    self.fill = function (value)
        for x, y, cell in self.iter() do
            self.cells[x][y] = value
        end
    end

    -- set all the cells in the array to nil:
    self.clear = function ()
        self.fill(nil)
    end

    -- count the number of cells in the array matching a function:
    self.count = function (test)
        local total = 0

        for x, y, cell in self.iter() do
            if test(cell) then
                total = total + 1
            end
        end

        return total
    end

    -- count the number of nil cells in the array:
    self.count_nil = function ()
        local test = function (cell)
            return cell == nil
        end

        return self.count(test)
    end

    -- count the number of non-nil cells in the array:
    self.count_not_nil = function ()
        local test = function (cell)
            return cell ~= nil
        end

        return self.count(test)
    end

    -- count the number of cells in the array matching a function
    -- from a starting coordinate in a given direction:
    self.count_direction = function (test, x, y, direction)
        local total = 0

        while true do
            x = x + direction.x
            y = y + direction.y

            if self.contains(x, y) and test(self.cells[x][y]) then
                total = total + 1
            else
                break
            end
        end

        return total
    end

    -- count the number of nil cells in the array
    -- from a starting coordinate in a given direction:
    self.count_nil_direction = function (x, y, direction)
        local test = function (cell)
            return cell == nil
        end

        return self.count_direction(test, x, y, direction)
    end

    -- count the number of not nil cells in the array
    -- from a starting coordinate in a given direction:
    self.count_not_nil_direction = function (x, y, direction)
        local test = function (cell)
            return cell ~= nil
        end

        return self.count_direction(test, x, y, direction)
    end

    -- get the (x, y) coordinates for the nth cell matching a function:
    self.nth = function (test, nth)
        for x, y, cell in self.iter() do
            if test(cell) then
                nth = nth - 1

                if nth == 0 then
                    return x, y
                end
            end
        end
    end

    -- get the (x, y) coordinates for the nth nil cell in the array:
    self.nth_nil = function (nth)
        local test = function (cell)
            return cell == nil
        end

        return self.nth(test, nth)
    end

    -- get the (x, y) coordinates for a random nil cell in the array:
    self.nth_random_nil = function ()
        local positions = self.count_nil()

        -- none available:
        if positions == 0 then
            return nil, nil
        end

        return self.nth_nil(math.random(positions))
    end

    self.init(width, height)
    return self
end

