---@diagnostic disable: lowercase-global, undefined-global
local love = require "love"
local Button = require "Components.Button"

function Game()
    backgroundMenu = love.graphics.newImage("image/background/finalT.png")
    frameSelectionMenu = love.graphics.newImage("image/Menu/Components/blackScreen.png")
    return {
        level = 1,
        countEnemyDie = 0,
        state = { -- các trạng thái trong một game
            menu = false,
            menuDouble = false,
            pause = false,
            running = false,
            exit = false,
        },
        
        main = {--
            settings = false
        },

        button_state = {
            menu = {},
            running = {},
        },

        DrawMenuGame = function ()
            love.graphics.draw(backgroundMenu, 0, 0)
            love.graphics.draw(frameSelectionMenu, 10, love.graphics.getHeight()/2 - frameSelectionMenu:getHeight()/2)
        end
    }

end

return Game
