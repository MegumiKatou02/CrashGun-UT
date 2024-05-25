local love = require "love"

function love.conf(t)
    t.window.title = "CrashGun - UT"
    t.window.icon = "image/icon/tt.jpg"
    t.window.display = 2
    t.window.width = 1000               -- The window width (number)
    t.window.height = 600
    t.window.msaa = 4
end