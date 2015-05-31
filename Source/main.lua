
-- Meve.
-- A simple, minimalistic puzzle game.


require 'game'


game = nil

-- Initialization:
function love.load ()
    math.randomseed(os.time())

    game = game_new()

    -- attach our callbacks:
    love.update = game.update
    love.draw = game.draw
    love.mousepressed = game.mousepressed
end

