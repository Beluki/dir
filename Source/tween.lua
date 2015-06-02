
-- dir.
-- A simple, minimalistic puzzle game.


-- Note:

-- All the tweens work with percentages and know nothing
-- about the stuff that is animated.


-- A "snap into place" animation:
function TweenAppearing ()
    local self = {}

    -- variables:
    self.running = false
    self.finished = false
    self.state = 'growing'

    self.size = 0
    self.alpha = 0
    self.offset_x = 0
    self.offset_y = 0

    -- constants:
    self.grow_speed = 375
    self.grow_max = 125

    self.shrink_speed = 150
    self.shrink_min = 100

    self.alpha_max = 100
    self.alpha_speed = self.grow_speed * 2.5

    -- reset the animation settings:
    self.reset = function ()
        self.running = false
        self.finished = false
        self.state = 'growing'

        self.size = 0
        self.alpha = 0
        self.offset_x = 0
        self.offset_y = 0
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

    return self
end


-- A "growing and fading out" animation:
function TweenDisappearing ()
    local self = {}

    -- variables:
    self.running = false
    self.finished = false

    self.size = 100
    self.alpha = 100
    self.offset_x = 0
    self.offset_y = 0

    -- constants:
    self.grow_speed = 100
    self.alpha_min = 0
    self.alpha_speed = 125

    -- reset the animation settings:
    self.reset = function ()
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0
    end

    -- update the animation logic:
    self.update = function (dt)
        if self.running then
            self.alpha = math.max(self.alpha - (self.alpha_speed * dt), self.alpha_min)
            self.size = self.size + (self.grow_speed * dt)

            if self.alpha == self.alpha_min then
                self.running = false
                self.finished = true
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

    return self
end


-- A growing animation:
function TweenGrowing ()
    local self = {}

    -- variables:
    self.running = false
    self.finished = false

    self.size = 100
    self.size_max = 100
    self.speed = 100

    self.alpha = 100
    self.offset_x = 0
    self.offset_y = 0

    -- reset the animation settings:
    self.reset = function ()
        self.running = false
        self.finished = false

        self.size = 100
        self.alpha = 100
        self.offset_x = 0
        self.offset_y = 0
    end

    -- update the animation logic:
    self.update = function (dt)
        if self.running then
            self.size = math.min(self.size + (self.speed * dt), self.size_max)

            if self.size == self.size_max then
                self.running = false
                self.finished = true
            end
        end
    end

    -- start animation:
    self.play = function (size)
        self.size_max = size
        self.speed = size
        self.running = true
    end

    -- stop animation:
    self.stop = function ()
        self.running = false
    end

    return self
end


-- A moving animation in a single direction (horizontal or vertical):
function TweenMoving ()
    local self = {}

    -- variables:
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

    -- reset the animation settings:
    self.reset = function ()
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

    -- update the animation logic:
    self.update = function (dt)
        if self.running then
            if self.moved < self.distance then
                local distance_x = math.abs(self.direction.X * (self.speed * dt))
                local distance_y = math.abs(self.direction.Y * (self.speed * dt))

                self.offset_x = math.min(self.offset_x + distance_x, self.distance)
                self.offset_y = math.min(self.offset_y + distance_y, self.distance)

                self.moved = self.moved + distance_x + distance_y
            else
                self.running = false
            end
        end
    end

    -- start animation:
    self.play = function (distance, direction)
        self.distance = distance
        self.direction = direction
        self.speed = distance * 2
        self.moved = 0
        self.running = true
    end

    -- stop animation:
    self.stop = function ()
        self.running = false
    end

    return self
end

