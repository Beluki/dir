
-- dir.
-- A simple, minimalistic puzzle game.


require 'game/game'


-- Initialization:
function love.load ()

    -- include Love version in the window title:
    local major, minor, revision, codename = love.getVersion()
    love.window.setTitle(string.format("dir (love2d %d.%d.%d)", major, minor, revision))

    -- initialize seed:
    math.randomseed(os.time())

    local game = Game()

    love.draw = game.draw
    love.update = game.update
    love.resize = game.resize
    love.keypressed = game.keypressed
    love.mousepressed = game.mousepressed
end

