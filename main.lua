---@diagnostic disable: lowercase-global
local love = require "love"
local Game = require "Game"

function love.load()
    game = Game();
    game.state["menu"] = true
end

function love.update(dt)
end

function love.draw()
    if game.state["menu"] then
        game:DrawMenuGame()
    end
end