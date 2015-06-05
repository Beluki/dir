
-- dir.
-- A simple, minimalistic puzzle game.


require 'constant'


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

    -- determine wheter a coordinate is in the array bounds:
    self.contains = function (x, y)
        return (x >= 1) and (x <= self.width) and (y >= 1) and (y <= self.height)
    end

    -- iterate the array from top-left to bottom-right, row by row
    -- and return (x, y, value) for each cell:
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
            for y = 1, self.height do
                for x = 1, self.width do
                    local cell = self.cells[x][y]

                    if cell ~= nil then
                        coroutine.yield(x, y, cell)
                    end
                end
            end
        end

        return coroutine.wrap(iterator)
    end

    -- iterate cells from a given starting
    -- point in the four cardinal directions:
    self.iter_directions = function (x, y)
        local iterator = function ()
            for name, coordinate in pairs(DIRECTIONS) do
                local cell_x = x + coordinate.x
                local cell_y = y + coordinate.y

                if self.contains(cell_x, cell_y) then
                    local cell = self.cells[cell_x][cell_y]
                    coroutine.yield(x, y, cell)
                end
            end
        end

        return coroutine.wrap(iterator)
    end

    -- iterate not nil cells from a given starting
    -- point in the four cardinal directions:
    self.iter_directions_not_nil = function (x, y)
        local iterator = function ()
            for name, direction in pairs(DIRECTIONS) do
                local cell_x = x + direction.X
                local cell_y = y + direction.Y

                if self.contains(cell_x, cell_y) then
                    local cell = self.cells[cell_x][cell_y]

                    if cell ~= nil then
                        coroutine.yield(x, y, cell)
                    end
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
            x = x + direction.X
            y = y + direction.Y

            if not self.contains(x, y) or not test(self.cells[x][y]) then
                break
            end

            total = total + 1
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

    -- get the (x, y) coordinates for the nth cell matching a function:
    self.nth = function (nth, test)
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

        return self.nth(nth, test)
    end

    -- get the (x, y) coordinates for a random nil cell in the array:
    self.nth_random_nil = function ()
        local positions = self.count_nil()

        -- no nil positions available:
        if positions == 0 then
            return nil
        end

        return self.nth_nil(math.random(positions))
    end

    -- swap the values of two cells in the grid with each other:
    self.swap = function (x1, y1, x2, y2)
        self.cells[x1][y1], self.cells[x2][y2] = self.cells[x2][y2], self.cells[x1][y1]
    end

    self.init(width, height)
    return self
end

