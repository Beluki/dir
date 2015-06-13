
-- dir.
-- A simple, minimalistic puzzle game.


-- Grid animations:

-- There are four animations:
-- Tiles appearing, disappearing, growing or moving.

-- The implementations are tween-like and work with percentages.
-- The idea is to keep animation logic separated from the grid semantics
-- and independent enough to be easy to understand in isolation.

-- One of them (or none) is active at any point during the gameplay
-- so there is a reset() method to reuse an animation with different
-- values, instead of creating a new object each time.


-- A "snap into place" animation for appearing tiles:
function GridTilesAppearing ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.running = false
        self.finished = false

        self.size = 0
        self.alpha = 0
        self.offset_x = 0
        self.offset_y = 0

        self.state = 'growing'

        -- constant:
        self.grow_max = 125
        self.grow_speed = 375

        self.shrink_min = 100
        self.shrink_speed = 150

        self.alpha_max = 100
        self.alpha_speed = self.grow_speed * 2.5
    end

    -- reset the animation settings:
    self.reset = function ()
        self.init()
    end

    -- update the animation when growing:
    self.update_growing = function (dt)
        self.size = math.min(self.size + (self.grow_speed * dt), self.grow_max)
        self.alpha = math.min(self.alpha + (self.alpha_speed * dt), self.alpha_max)

        if self.size == self.grow_max then
            self.alpha = self.alpha_max
            self.state = 'shrinking'
        end
    end

   -- update the animation when shrinking:
    self.update_shrinking = function (dt)
        self.size = math.max(self.size - (self.shrink_speed * dt), self.shrink_min)

        if self.size == self.shrink_min then
            self.running = false
            self.finished = true
            self.oncomplete()
        end
    end

    -- update the animation logic:
    self.update = function (dt)
        if self.running then
            if self.state == 'growing' then
                self.update_growing(dt)
            else
                self.update_shrinking(dt)
            end
        end
    end

   -- start animation:
    self.play = function ()
        self.running = true
    end

    -- stop animation:
    self.stop = function ()
        self.running = false
    end

    -- completion callback:
    self.oncomplete = function ()
    end

    self.init()
    return self
end


-- A "growing and fading out" animation for disappearing tiles:
function GridTilesDisappearing ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0

        -- constant:
        self.grow_speed = 75
        self.alpha_min = 0
        self.alpha_speed = 250
    end

    -- reset the animation settings:
    self.reset = function ()
        self.init()
    end

    -- update the animation logic:
    self.update = function (dt)
        if self.running then
            self.alpha = math.max(self.alpha - (self.alpha_speed * dt), self.alpha_min)
            self.size = self.size + (self.grow_speed * dt)

            if self.alpha == self.alpha_min then
                self.running = false
                self.finished = true
                self.oncomplete()
            end
        end
    end

   -- start animation:
    self.play = function ()
        self.running = true
    end

    -- stop animation:
    self.stop = function ()
        self.running = false
    end

    -- completion callback:
    self.oncomplete = function ()
    end

    self.init()
    return self
end


-- A growing animation for tiles matching their neighbours:
function GridTilesGrowing ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0

        self.grow_max = 0
        self.speed = 0
    end

    -- reset the animation settings:
    self.reset = function (grow_max)
        self.init()

        self.grow_max = grow_max
        self.speed = grow_max * 3
    end

    -- update the animation logic:
    self.update = function (dt)
        if self.running then
            self.size = math.min(self.size + (self.speed * dt), self.grow_max)

            if self.size == self.grow_max then
                self.running = false
                self.finished = true
                self.oncomplete()
            end
        end
    end

    -- start animation:
    self.play = function ()
        self.running = true
    end

    -- stop animation:
    self.stop = function ()
        self.running = false
    end

    -- completion callback:
    self.oncomplete = function ()
    end

    self.init()
    return self
end


-- A moving animation in a single direction (horizontal or vertical)
-- for tiles that are moving towards a target:
function GridTilesMoving ()
    local self = {}

    -- initialization:
    self.init = function ()
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0

        self.distance = 0
        self.direction = nil
        self.moved = 0
        self.speed = 0
    end

    -- reset the animation settings:
    self.reset = function (distance, direction)
        self.init()

        self.distance = distance
        self.direction = direction
        self.speed = distance * 3.5
    end

    -- update the animation logic:
    self.update = function (dt)
        if self.running then
            self.offset_x = self.offset_x + (self.direction.x * (self.speed * dt))
            self.offset_y = self.offset_y + (self.direction.y * (self.speed * dt))

            self.moved = math.abs(self.offset_x) + math.abs(self.offset_y)

            if self.moved >= self.distance then
                self.offset_x = self.direction.x * self.distance
                self.offset_y = self.direction.y * self.distance

                self.moved = self.distance

                self.running = false
                self.finished = true
                self.oncomplete()
            end
        end
    end

    -- start animation:
    self.play = function ()
        self.running = true
    end

    -- stop animation:
    self.stop = function ()
        self.running = false
    end

    -- completion callback:
    self.oncomplete = function ()
    end

    self.init()
    return self
end

