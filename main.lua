---@diagnostic disable: lowercase-global
local love = require "love"
local Game = require "Game"
local Button = require "Components.Button"
local Player = require "Player"
local bullets = require "Bullets"

-- local mys = love.mouse.getX() .. " " .. love.mouse.getY()

function ChangeChoose(state)
    game.state.choose["settings"] = state == "settings"
end

function ChangeGameState(state)
    game.state["menu"] = state == "menu"
    game.state["menuDouble"] = state == "menuDouble"
    game.state["pause"] = state == "pause"
    game.state["running"] = state == "running"
    game.state["exit"] = state == "exit"
end

function CheckOutSideTheRectangle(x, y, width, height, mouse_x, mouse_y)
    if mouse_x < x or mouse_x > x + width or mouse_y < y or mouse_y > y + height then
        return true
    else return false
    end
end

function createBullet(x, y, angle)
    local bullet = {
        x = x,
        y = y,
        angle = angle,
        speed = player.bulletSpeed
    }
    table.insert(Bullet.bullets, bullet)
end

function GunShooting(dt)
    if not player.canShoot then
        player.shootTimer = player.shootTimer - dt
        if player.shootTimer <= 0 then
            player.canShoot = true
        end
    end

    if love.keyboard.isDown("j") and player.canShoot then
        createBullet(player.x, player.y, player.angle)
        player.canShoot = false
        player.shootTimer = player.shootDelay
    end

    for i = #Bullet.bullets, 1, -1 do
        local bull = Bullet.bullets[i]
        bull.x = bull.x + bull.speed * math.cos(bull.angle) * dt
        bull.y = bull.y + bull.speed * math.sin(bull.angle) * dt

        -- Xóa đạn nếu nó ra khỏi màn hình
        if bull.x < 0 or bull.x > love.graphics.getWidth() or bull.y < 0 or bull.y > love.graphics.getHeight() then
            table.remove(Bullet.bullets, i)
        end
    end
end

function StartGame()
    ChangeGameState("running")
end

function LoadMenu()
    game.button_state.menu.play_game = Button(230, 100, "Game mới", ChangeGameState, "menuDouble")
    game.button_state.menu.setting_game = Button(230, 100, "Cài đặt", ChangeChoose, "settings")
    game.button_state.menu.information_game = Button(230, 100, "Cửa hàng", nil, nil)
    game.button_state.menu.exit_game = Button(230, 100, "Thoát game", love.event.quit, nil)

    game.button_state.menu.select_mode_easy = Button(230, 320, "Chế độ \n\tDỄ", ChangeGameState, "running")
    game.button_state.menu.select_mode_hard = Button(230, 320, "Chế độ \n\tKHÓ", nil, nil)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.state["menu"] then
            for index in pairs(game.button_state.menu) do
                if game.button_state.menu[index] ~= game.button_state.menu.select_mode_easy  and
                   game.button_state.menu[index] ~= game.button_state.menu.select_mode_hard then
                    ChangeChoose()
                    game.button_state.menu[index]:checkPressed(x, y)
                end
            end
        elseif game.state["menuDouble"] then
            local lenX, lenY = 520, 355
            local recX = love.graphics.getWidth() / 2 - (lenX / 2)
            local recY = love.graphics.getHeight() / 2 - (lenY / 2)
            if CheckOutSideTheRectangle(recX, recY, lenX, lenY, love.mouse.getX(), love.mouse.getY()) then
                ChangeGameState("menu")
                game.state["menuDouble"] = false
            else
                for index in pairs(game.button_state.menu) do
                    game.button_state.menu[index]:checkPressed(x, y)
                end
            end
        end
    end
end

function SettingMenu()
    love.graphics.rectangle("fill", 300, 26, 660, 550)
end

--#region main
function love.load()
    avatarPlayer = love.graphics.newImage("image/icon/tt.jpg")
    game = Game()
    player = Player()
    Bullet = bullets()
    game.state["menu"] = true
    LoadMenu()
end

function love.update(dt)
    if game.state["menuDouble"] then
        mys = love.mouse.getX() .. " " .. love.mouse.getY()
    else
        for index in pairs(game.state) do
            if game.state[index] then
                mys = index
            end
        end
    end
    if game.state["running"] then
        player:move(dt)
        GunShooting(dt)
    end
end

function love.draw()
    if game.state["menu"] or game.state["menuDouble"] then
        game:DrawMenuGame()
        game.button_state.menu.play_game:draw(20, 35, nil, nil)
        game.button_state.menu.setting_game:draw(20, 150, nil, nil)
        game.button_state.menu.information_game:draw(20, 265, nil, nil)
        game.button_state.menu.exit_game:draw(20, 380, nil, nil)

        --
        if game.state["menuDouble"] then
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setColor(1, 1, 1, 1)

            love.graphics.setColor(13/225, 12/225, 12/225)
            local lenX, lenY = 520, 355
            local recX = love.graphics.getWidth() / 2 - lenX / 2
            local recY = love.graphics.getHeight()/ 2 - lenY / 2
            love.graphics.rectangle("fill",recX, recY, lenX, lenY)
            love.graphics.setColor(1, 1, 1)
            game.button_state.menu.select_mode_easy:draw(recX + 20, recY + 17, 40, 25)
            game.button_state.menu.select_mode_hard:draw(recX * 2 + 30, recY + 17, 40, 25)
            love.graphics.setColor(1, 1, 1)
        end
        if game.state.choose["settings"] then
            SettingMenu()
        end
    elseif game.state["running"] then
        love.graphics.setColor(40/225, 222/225, 49/225)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 100)

        player:draw()

        for _, bull in ipairs(Bullet.bullets) do
            -- Tính toán tọa độ của điểm kết thúc của đoạn thẳng
            local endX = bull.x + math.cos(bull.angle) * 20 -- 20 là độ dài của đoạn thẳng
            local endY = bull.y + math.sin(bull.angle) * 20
    
            -- Vẽ đoạn thẳng
            love.graphics.setLineWidth(5)
            love.graphics.setColor(0, 0, 0)
            love.graphics.line(bull.x, bull.y, endX, endY)
            love.graphics.setColor(1, 1, 1)
        end
        --#region frame
        love.graphics.draw(avatarPlayer, 0, 0, 0, 0.15, 0.15)
        love.graphics.rectangle("fill", 85, 0, 400, 40)
        for i = 85, player.blood, 10 do
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", i, 0, 10, 40)
        end
        love.graphics.setColor(1, 1, 1)
        --#endregion
    else
        -- for index in pairs(game.state) do
        --     if game.state[index] then
        --         love.graphics.print(index, 300, 400)
        --     end
        -- end
        -- love.graphics.print(">", 300, 500)
    end
    love.graphics.print(mys, 80, 500)
--#endregion
end