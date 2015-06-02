
-- dir.
-- A simple, minimalistic puzzle game.


require 'game'


-- Initialization:
function love.load ()
    math.randomseed(os.time())

    game = Game()

    -- attach our callbacks:
    love.update = game.update
    love.draw = game.draw
    love.mousepressed = game.mousepressed
end

