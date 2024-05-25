---@diagnostic disable: lowercase-global
local love = require "love"
local Game = require "Game"
local Button = require "Components.Button"

function ChangeGameState(state)
    game.state["menu"] = state == "menu"
    game.state["pause"] = state == "pause"
    game.state["running"] = state == "running"
    game.state["exit"] = state == "exit"
end

function LoadMenu()
    game.button_state.menu.play_game = Button(230, 100, "Game mới", ChangeGameState, "running")
    game.button_state.menu.setting_game = Button(230, 100, "Cài đặt", nil, nil)
    game.button_state.menu.information_game = Button(230, 100, "Cửa hàng", nil, nil)
    game.button_state.menu.exit_game = Button(230, 100, "Thoát game", love.event.quit, nil)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.state["menu"] then
            for index in pairs(game.button_state.menu) do
                game.button_state.menu[index]:checkPressed(x, y)
            end
        end
    end
end

function love.load()
    game = Game();
    game.state["menu"] = true
    LoadMenu()
end

function love.update(dt)
    if game.state["menu"] then
    
    end
end

function love.draw()
    if game.state["menu"] then
        game:DrawMenuGame()
        game.button_state.menu.play_game:draw(20, 35, 10, 10)
        game.button_state.menu.setting_game:draw(20, 150, 10, 10)
        game.button_state.menu.information_game:draw(20, 265, 10, 10)
        game.button_state.menu.exit_game:draw(20, 380, 10, 10)
    elseif game.state["running"] then

    else
        -- for index in pairs(game.state) do
        --     if game.state[index] then
        --         love.graphics.print(index, 300, 400)
        --     end
        -- end
        -- love.graphics.print(">", 300, 500)
    end
end