local love = require "love"

local function custom_atan2(dy, dx)
    if dx > 0 then
        return math.atan(dy / dx)
    elseif dx < 0 and dy >= 0 then
        return math.atan(dy / dx) + math.pi
    elseif dx < 0 and dy < 0 then
        return math.atan(dy / dx) - math.pi
    elseif dx == 0 and dy > 0 then
        return math.pi / 2
    elseif dx == 0 and dy < 0 then
        return -math.pi / 2
    else
        return 0 -- dx == 0 and dy == 0, góc không xác định
    end
end


function Monster(_x, _y, speed)
    return {
        image = love.graphics.newImage("image/monster/monster.png"),
        x = _x or 100,
        y = _y or 100,
        blood = 3,
        speed = speed or 60,
        angle = math.rad(-90),

        move = function (self, player_x, player_y, dt)
            local dx = player_x - self.x
            local dy = player_y - self.y
            self.angle = custom_atan2(dy, dx)
            
            -- Di chuyển con quái về phía người chơi
            local distance = math.sqrt(dx * dx + dy * dy)
            if distance > 0 then
                self.x = self.x + (dx / distance) * self.speed * dt
                self.y = self.y + (dy / distance) * self.speed * dt
            end
        end,

        draw = function (self)
            love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
        end
    }
end

return Monster