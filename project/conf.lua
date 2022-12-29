local love = require "love"

function love.conf(app)
    app.version = "1.1.1"
    app.window.icon = "nasa.jpeg"
    app.window.width = 1280
    app.window.height = 720
    app.window.resizable = true
    app.window.title = "SPACESHIP"
    app.window.display = 2
end