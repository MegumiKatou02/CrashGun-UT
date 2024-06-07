---@diagnostic disable: lowercase-global, undefined-global
local love = require "love"
local Button = require "Components.Button"

function Game()
    backgroundMenu = love.graphics.newImage("image/background/finalT.png")
    frameSelectionMenu = love.graphics.newImage("image/Menu/Components/blackScreen.png")
    local FileDirectory = "chinh.txt"
    return {
        backgroundRunning = love.graphics.newImage("image/background/backgroundT.jpg"),
        level = 1,
        countEnemyDie = 0,
        coin = 0,
        state = { -- các trạng thái trong một game
            menu = false,
            menuDouble = false,
            pause = false,
            running = false,
            exit = false,
        },
        
        main = {
            settings = false
        },

        button_state = {
            menu = {},
            running = {},
        },

        DrawMenuGame = function ()
            love.graphics.draw(backgroundMenu, 0, 0)
            love.graphics.draw(frameSelectionMenu, 10, love.graphics.getHeight()/2 - frameSelectionMenu:getHeight()/2)
        end,

        SaveGame = function (self)
            local saveData = tostring(self.coin) .. "," .. tostring(self.level)
            love.filesystem.write(FileDirectory, saveData)
        end,

        LoadGame = function ()
            local saveString = love.filesystem.read(FileDirectory)
            if saveString then
                local coin, level = saveString:match("([^,]+),([^,]+)")
                coin = tonumber(coin) or 0
                level = tonumber(level) or 1
                return coin, level
            else
                return 0, 1 -- Giá trị mặc định nếu không có file lưu
            end
        end,
    }

end

return Game