require "globals"
local love = require "love"


function asteroids(x, y, ast_size, level)
    local ast_vert = 10
    local ast_jag = 0.5
    local ast_speed = math.random(50) + (level * 5)
    local vert = math.floor(math.random(ast_vert + 1) + ast_vert / 2)
    local offset = {}
    for i = 1,vert + 1 do
        table.insert(offset, math.random() * ast_jag * 2 + 1 - ast_jag)
    end
    local vel = -1
    if math.random() < 0.5 then
        vel = 1
    end

    return{
        x = x,
        y = y,
        x_vel = math.random() * ast_speed * vel,
        y_vel = math.random() * ast_speed * vel,
        radius = math.ceil(ast_size/2),
        angle = math.rad(math.random(math.pi)),
        vert = vert,
        offset = offset,

        draw = function(self,faded)
            local opacity = 1
            if faded then
                opacity = 0.2
            end

            love.graphics.setColor(0.83, 0.84, 0.82)
            
            local points = { 
                self.x + self.radius * self.offset[1] * math.cos(self.angle),
                self.y + self.radius * self.offset[1] * math.sin(self.angle)
            }

            for i = 1, self.vert - 1 do
                table.insert(points, self.x + self.radius * self.offset[i + 1] * math.cos(self.angle + i * math.pi * 2/ self.vert))
                table.insert(points, self.y + self.radius * self.offset[i + 1] * math.sin(self.angle + i * math.pi * 2/ self.vert))
            end

            love.graphics.polygon(
                "line",
                points
            )

            if show_debugging then
                love.graphics.setColor(1, 0, 0)
                love.graphics.circle("line", self.x, self.y, self.radius)
            end
        end,

        move = function (self, dt)
            self.x = self.x + self.x_vel * dt
            self.y = self.y + self.y_vel * dt

            if self.x + self.radius < 0 then
                self.x = love.graphics.getWidth() + self.radius
            end
            if self.x - self.radius > love.graphics.getWidth() then
                self.x = - self.radius
            end
            if self.y + self.radius < 0 then
                self.y = love.graphics.getHeight() + self.radius
            end
            if self.y - self.radius > love.graphics.getHeight() then
                self.y = - self.radius
            end
        end,

        ast_destroy = function(self, aasteroid_tbl, index, game)
            local min_size = math.ceil(ast_size/6)
            if self.radius/2.5 > min_size then
                
                table.insert(aasteroid_tbl, asteroids(self.x, self.y, self.radius, game.level))
                table.insert(aasteroid_tbl, asteroids(self.x, self.y, self.radius, game.level))  
                
                

            end
            
            table.remove(aasteroid_tbl, index)
        end

    }
end
return asteroids