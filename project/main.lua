require "globals"
local love = require "love"
local player = require "objects/player"
local game = require "state/game"


math.randomseed(os.time())

function love.load()
    love.mouse.setVisible(false)
    mousex, mousey = 0, 0
    player = player(1)
    game = game()
    game:start_new_game(player)   -- isos xreiastei na alaxo to proto menu
end

function love.keypressed(key)
    if game.state.running then
        if key == "w" or  key == "up" then
            player.thrusting = true
        end
        if key == "space" or  key == "down" then
            player:shoot()
        end
        if key == "escape" then
            game:change_state("paused")
        end
    elseif game.state.paused then
        if key == "escape" then
            game:change_state("running")
        end
    end
end

function love.keyreleased(key)
    if key == "w" or  key == "up" then
        player.thrusting = false
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.state.running then
            player:shoot()
        end
    end
end

function love.update(dt)
    mousex, mousey = love.mouse.getPosition()
    if game.state.running then
        player:move()

        for ast_index, asteroid in pairs(aasteroids) do 
            if not player.exploading then
                if calculate_distance(player.x, player.y, asteroid.x, asteroid.y) < asteroid.radius then
                    player:expload()
                    ast_destraction = true
                end
            else
                player.expload_time = player.expload_time - 1
                --if player.expload_time == 0 then
                  --  if player.lives - 1 <= 0 then
                        game:change_state("ended")
                    
                        return
                    --end
                    --player = player(player.lives - 1)
                --end
            end   


            for _, laser in pairs (player.lasers) do
                if calculate_distance(laser.x, laser.y, asteroid.x, asteroid.y) < asteroid.radius then
                    laser:expload()
                    asteroid:ast_destroy(aasteroids, ast_index, game)
                end
            end

            if ast_destraction then
                ast_destraction = false
                asteroid:ast_destroy(aasteroids, ast_index, game)
            end

            asteroid:move(dt)
        end
    end
end

function love.draw()
    if game.state.running or game.state.paused then
        player:draw_lives(game.state.paused)
        player:draw(game.state.paused)

        for _,asteroid in pairs(aasteroids) do
            
            asteroid:draw(game.state.paused)
        end
        game:draw(game.state.paused)
    elseif game.state.ended then
        game:draw()
    end
    player:draw_lives(game.state.paused)
    love.graphics.setColor(1,1,1)
    love.graphics.print(love.timer.getFPS(), 10, 10)
    
end