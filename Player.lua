local love = require "love"

function Player()
    local skin = "image/playerSkin/players.png"
    local rotateRadian = 200
    return {
        x = love.graphics.getWidth() / 2, -- Vị trí giữa màn hình
        y = love.graphics.getHeight() / 2,
        skin = love.graphics.newImage(skin),
        angle = math.rad(-90), -- Góc quay ban đầu là -π/2 radian (90 độ ngược chiều kim đồng hồ từ hướng phải)
        rotationSpeed = math.rad(rotateRadian), -- Tốc độ quay, đơn vị radian/giây
        bulletSpeed = 1900, -- Tốc độ của đạn
        shootDelay = 0.1, -- Thời gian chờ giữa mỗi lần bắn (giây)
        canShoot = true, -- Biến trạng thái cho phép bắn
        shootTimer = 0, -- Thời gian đếm để xác định thời điểm tiếp theo có thể bắn
        speed = 149,
        blood = 400 + 85,
        radius = 15,

        move = function (self, dt)
            if love.keyboard.isDown("w") then
                self.x = self.x + math.cos(self.angle) * self.speed * dt
                self.y = self.y + math.sin(self.angle) * self.speed * dt
            end
            if love.keyboard.isDown("s") then
                self.x = self.x - math.cos(self.angle) * self.speed * dt
                self.y = self.y - math.sin(self.angle) * self.speed * dt
            end
            if love.keyboard.isDown("a") then
                self.angle = self.angle - self.rotationSpeed * dt
            end
            if love.keyboard.isDown("d") then
                self.angle = self.angle + self.rotationSpeed * dt
            end
        end,

        draw = function (self)
            love.graphics.draw(self.skin, self.x, self.y, self.angle, 1, 1, self.skin:getWidth() / 2, self.skin:getHeight() / 2)
        end,

        ChangeSkin = function (self, newSKin)
            self.skin = newSKin or "image/playerSkin/players.png"
        end,

        ChangeUpRotate = function (self, nough)
            self.rotateRadian = self.rotateRadian + nough
        end
    }
end

return Player