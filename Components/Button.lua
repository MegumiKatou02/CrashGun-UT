---@diagnostic disable: undefined-global, lowercase-global
local love = require "love"

function Button(width, height, text, func, func_parameter)
    local dpi = love.graphics.getDPIScale()
    mainFont = love.graphics.newFont("font/NotoSansTC-Medium.ttf", 30 * dpi)
    return {
        width = width or 100,
        height = height or 100,
        func = func or function ()
            print("This button has no function attached")
        end,
        button_x = 10,
        button_y = 10,
        text_x = 10,
        text_y = 10,
        text = text or "No Text",


        checkPressed = function (self, mouse_x, mouse_y)
            
        end,

        draw = function (self, button_x, button_y, text_x, text_y)
            self.button_x = button_x or self.button_x
            self.button_y = button_y or self.button_y

            if text_x then
                self.text_x = text_x + button_x
            else
                self.text_x = self.button_x
            end

            if text_y then
                self.text_y = text_y + button_y
            else
                self.text_y = self.button_y
            end
            
            love.graphics.rectangle("fill", self.button_x, self.button_y, self.width, self.height)
            
            love.graphics.setFont(mainFont)
            
            local textWidth = mainFont:getWidth(text)
            local textHeight = mainFont:getHeight()
            
            -- Tính toán vị trí để đặt văn bản vào chính giữa hình chữ nhật
            local textX = self.button_x + (self.width - textWidth) / 2
            local textY = self.button_y + (self.height - textHeight) / 2

            love.graphics.setColor(0.6, 0.6, 0.6)

            love.graphics.setColor(0, 0, 0)

            love.graphics.print(self.text, textX, textY)

            love.graphics.setColor(1, 1, 1)
        end
    }
end

return Button