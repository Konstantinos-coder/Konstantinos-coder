local love = require "love"
require "globals"
local text = require "../components/text"
local asteroids = require "../objects/asteroids"

function game()
    
    return{
        level = 1,
        state = {
            menu = false,
            paused = false,
            running = true,
            ended = false
        },
        screen_text = {},
        game_over_showing = false,
    
        change_state = function (self, state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"
            
            if self.state.ended then
                self:game_over()
            end
        end,

        game_over = function (self)
            self.screen_text = {
                text(
                    "GAME OVER",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    true,
                    true,
                    love.graphics.getWidth(),
                    "center"
                )
            }

            self.game_over_showing = true
        end,

        draw = function(self, faded)
            
            if faded then
                text(
                    "PAUSED",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h4",
                    false,
                    false,
                    love.graphics.getWidth(),
                    "center"
                ):draw()
            end

            for index, text in pairs(self.screen_text) do
                if self.game_over_showing then
                    self.game_over_showing = text:draw(self.screen_text,index)
                end
            end
        end,

        start_new_game = function(self,player)
            
            self:change_state("running")       
            aasteroids = {}
            local ast_x = math.floor(math.random(love.graphics.getWidth()))
            local ast_y = math.floor(math.random(love.graphics.getHeight()))
            table.insert(aasteroids, 1, asteroids(ast_x, ast_y, 100, self.level))
        end

    }
end
return game