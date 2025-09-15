notbalatro = true

local GAME_WIDTH = 71
local GAME_HEIGHT = 95
local SCALE = 8

local gameCanvas

puyoSeed = puyoSeed or love.math.random(1, 10000)
love.math.setRandomSeed(puyoSeed)

-- Require the main game logic from src/
local Game = require("src.game")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(GAME_WIDTH * SCALE, GAME_HEIGHT * SCALE, {
        resizable = false,
        vsync = true,
    })

    gameCanvas = love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT)
    gameCanvas:setFilter("nearest", "nearest")

    Game.load()
end

function love.update(dt)
    Game.update(dt)
end

function love.draw()
    love.graphics.setCanvas(gameCanvas)
    love.graphics.clear(0.1, 0.1, 0.1, 1)
    Game.draw(6, 6)
    love.graphics.setCanvas()
    love.graphics.draw(gameCanvas, 0, 0, 0, SCALE, SCALE)
end

function love.keypressed(key)
    if Game.keypressed then
        Game.keypressed(key)
    end
end

function love.keyreleased(key)
    if Game.keyreleased then
        Game.keyreleased(key)
    end
end