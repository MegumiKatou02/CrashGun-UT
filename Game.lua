---@diagnostic disable: lowercase-global
local love = require "love"

function Game()
    backgroundMenu = love.graphics.newImage("image/background/final.png")
    return {
        state = { -- các trạng thái trong một game
            menu = false,
            pause = false,
            running = false,
            exit = false,
        },

        ChangeGameState = function (self, state)
            self.menu = state == "menu"
            self.pause = state == "pause"
            self.running = state == "running"
            self.exit = state == "exit"
        end,

        DrawMenuGame = function ()
            love.graphics.draw(backgroundMenu, 0, 0, 0, 2, 2)
        end
    }

end

return Game