---@diagnostic disable: lowercase-global, undefined-global
local love = require "love"
local Button = require "Components.Button"

function Game()
    backgroundMenu = love.graphics.newImage("image/background/finalT.png")
    frameSelectionMenu = love.graphics.newImage("image/Menu/Components/blackScreen.png")
    return {
        state = { -- các trạng thái trong một game
            menu = false,
            pause = false,
            running = false,
            exit = false,
        },

        button_state = {
            menu = {}
        },

        ChangeGameState = function (self, state)
            self.menu = state == "menu"
            self.pause = state == "pause"
            self.running = state == "running"
            self.exit = state == "exit"
        end,

        DrawMenuGame = function ()
            love.graphics.draw(backgroundMenu, 0, 0)
            love.graphics.draw(frameSelectionMenu, 10, love.graphics.getHeight()/2 - frameSelectionMenu:getHeight()/2)
        end
    }

end

return Game