local love = require "love"

function love.conf(t)
    t.window.title = "CrashGun - UT"
    t.window.display = 2
    t.window.width = 1000               -- The window width (number)
    t.window.height = 600
end