notbalatro = true

require("src.misc_functions")
local game = require("src.game")

game.canvasWidth = 59
game.canvasHeight = 65
game.scale = 8
game.blockSize = math.floor(math.min(game.canvasWidth / 10, game.canvasHeight / 20))
game.gridOffsetX = 15
game.gridOffsetY = 1
tetrisSeed = tetrisSeed or love.math.random(1, 10000)
love.math.setRandomSeed(tetrisSeed)

function love.load()
    love.graphics.setBackgroundColor(game.colors.background)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(game.canvasWidth * game.scale, game.canvasHeight * game.scale, {resizable = false, vsync = true})
    game.canvas = love.graphics.newCanvas(game.canvasWidth, game.canvasHeight)
    game.load()
end

game.targetFrameTime = 1 / 60

function love.update(dt)
    local startTime = love.timer.getTime()

    game.update(dt)

    local frameTime = love.timer.getTime() - startTime

    if frameTime < game.targetFrameTime then
        love.timer.sleep(game.targetFrameTime - frameTime)
    end
end

function love.draw()
    love.graphics.setCanvas(game.canvas)
    love.graphics.clear()
    game.draw(nil, 2)
    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(game.canvas, 0, 0, 0, game.scale, game.scale)
end

function love.keypressed(key)
    game.keypressed(key)
end

function love.keyreleased(key)
    game.keyreleased(key)
end

function love.conf(t)
    t.window.width = game.canvasWidth * game.scale
    t.window.height = game.canvasHeight * game.scale
    t.console = true
end