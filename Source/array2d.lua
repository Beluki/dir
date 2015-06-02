
-- dir.
-- A simple, minimalistic puzzle game.


-- Create a new two-dimensional array:
function Array2d(width, height)
    local self = {}

    self.cells = {}
    self.width = width
    self.height = height

    -- initialize the array:
    for x = 1, self.width do
        self.cells[x] = {}

        for y = 1, self.height do
            self.cells[x][y] = nil
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

    -- iterate the array from top-left to bottom-right, row by row
    -- and return (x, y, value) for each cell:
    self.iter = function ()
        local iterate = function ()
            for y = 1, self.height do
                for x = 1, self.width do
                    coroutine.yield(x, y, self.cells[x][y])
                end
            end
        end

        return coroutine.wrap(iterate)
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

    -- get the (x, y) coordinates for a random nil position in the array:
    self.nth_random_nil = function ()
        local positions = self.count_nil()

        -- no nil positions available:
        if positions == 0 then
            return nil
        end

        return self.nth_nil(math.random(positions))
    end

    return self
end

