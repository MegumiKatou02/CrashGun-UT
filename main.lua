---@diagnostic disable: lowercase-global
local love = require "love"
local Game = require "Game"
local Button = require "Components.Button"
local Player = require "Player"
local bullets = require "Bullets"
local Monster = require "Monster.Monster"

enemies = {}
local spawnTimer = 0
local spawnInterval = 5

function ChangeChoose(state)
    game.main["settings"] = state == "settings"
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

function SettingMenu()
    love.graphics.rectangle("fill", 300, 26, 660, 550)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 400, 50, 100, 100)
    love.graphics.setColor(1, 1, 1)
end

function LoadMenu()
    game.button_state.menu.play_game = Button(230, 100, "Game mới", ChangeGameState, "menuDouble")
    game.button_state.menu.information_game = Button(230, 100, "Cửa hàng", nil, nil)
    game.button_state.menu.exit_game = Button(230, 100, "Thoát game", love.event.quit, nil)
    game.button_state.menu.setting_game = Button(230, 100, "Cài đặt", ChangeChoose, "settings")
    
    game.button_state.menu.select_mode_easy = Button(230, 320, "Chế độ \n\tDỄ", ChangeGameState, "running")
    game.button_state.menu.select_mode_hard = Button(230, 320, "Chế độ \n\tKHÓ", nil, nil)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        --#region choose main screen
        if game.state["menu"] then
            for index in pairs(game.button_state.menu) do
                if game.button_state.menu[index] ~= game.button_state.menu.select_mode_easy  and
                   game.button_state.menu[index] ~= game.button_state.menu.select_mode_hard then
                    ChangeChoose("")
                    game.button_state.menu[index]:checkPressed(x, y)
                    if game.main["settings"] then -- trường hợp gặp settings thì break
                        break
                    end
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
        elseif game.state["running"] then
            -- if button == 1 and player.canShoot then
            --     createBullet(player.x, player.y, player.angle)
            --     player.canShoot = false
            --     player.shootTimer = player.shootDelay
            -- end
        end
        --#endregion
    end
end

--#region main file
function love.load()
    avatarPlayer = love.graphics.newImage("image/icon/tt.jpg")
    game = Game()
    -- monster = Monster(50)
    table.insert(enemies, Monster(-1, -1, 50))
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
        checkCollisions()
        checkPlayerCollision()
        -- monster:move(player.x, player.y, dt)
        spawnTimer = spawnTimer + dt
        spawnInterval = calculateSpawnInterval(game.level)
        if spawnTimer >= spawnInterval then
            spawnEnemy(60)
            spawnTimer = 0
        end
        for _, enemy in ipairs(enemies) do
            enemy:move(player.x, player.y, dt)
        end
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
        if game.main["settings"] then
            SettingMenu()
        end
    elseif game.state["running"] then
        love.graphics.setColor(40/225, 222/225, 49/225)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 100)

        local sizeWidthScreen = love.graphics.getWidth();
        love.graphics.circle("fill", sizeWidthScreen - 50, 20 , 20)

        player:draw()
        
        for _, enemy in ipairs(enemies) do
            enemy:draw()
        end

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
        love.graphics.print("Level " .. game.level, 0, 75)
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

function spawnEnemy(speed)
    local side = math.random(1, 4)
    local x, y
    if side == 1 then -- Trên màn hình
        x = math.random(0, love.graphics.getWidth())
        y = -30
    elseif side == 2 then -- Dưới màn hình
        x = math.random(0, love.graphics.getWidth())
        y = love.graphics.getHeight() + 30
    elseif side == 3 then -- Bên trái màn hình
        x = -30
        y = math.random(0, love.graphics.getHeight())
    else -- Bên phải màn hình
        x = love.graphics.getWidth() + 30
        y = math.random(0, love.graphics.getHeight())
    end
    table.insert(enemies, Monster(x, y, speed))
end

function checkCollisions()
    for i = #Bullet.bullets, 1, -1 do
        local bullet = Bullet.bullets[i]
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            if checkCollision(bullet.x, bullet.y, enemy.x, enemy.y, enemy.image_spider:getWidth()/2) then
                table.remove(Bullet.bullets, i)
                if enemy.blood <= 1 then
                    table.remove(enemies, j)
                    game.countEnemyDie = game.countEnemyDie + 1;
                    if game.countEnemyDie >= 5 then
                        game.countEnemyDie = 0;
                        game.level = game.level + 1;
                    end
                else 
                    enemy.blood = enemy.blood -1; -- *n
                end
                break
            end
        end
    end
end

-- Hàm kiểm tra va chạm giữa đạn và quái vật (tròn)????
function checkCollision(bx, by, ex, ey, eradius)
    local dx = bx - ex
    local dy = by - ey
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance < eradius
end

function checkPlayerCollision()
    for _, enemy in ipairs(enemies) do
        if checkCollision(player.x, player.y, enemy.x, enemy.y, player.radius + enemy.image_spider:getWidth()/2) then
            if player.blood <= 2 then
                love.event.quit();
            end
            player.blood = player.blood - 1;
        end
    end
end

local spawnIntervalBase = 5
local spawnIntervalMin = 0.5

function calculateSpawnInterval(level)
    return math.max(spawnIntervalMin, spawnIntervalBase - 1.1*math.log(level + 1))
end