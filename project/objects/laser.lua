local love = require "love"


function laser(x, y, angle)
    local laser_speed = 500
    local duration = 0.4
    return{
        x = x,
        y = y,
        x_vel = laser_speed * math.cos(angle) / love.timer.getFPS(),
        y_vel = -laser_speed * math.sin(angle) / love.timer.getFPS(),
        distance = 0,
        exploading = 0,
        expload_time = 0,

        draw = function(self, faded)
            local opacity = 1

            if faded then 
                opacity = 0.2
            end

            if self.exploading < 1 then
                love.graphics.setColor(1, 0, 0, opacity)
                love.graphics.setPointSize(5)
                love.graphics.points(self.x, self.y)
            else
                love.graphics.setColor(1, 0.41, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 7)
            end         
        end,

        move = function ( self )
            self.x = self.x + self.x_vel
            self.y = self.y + self.y_vel

            if self.expload_time > 0 then
                self.exploading = 1
            end

            if self.x < 0 then
                self.x = love.graphics.getWidth()
            end
            if self.x > love.graphics.getWidth() then
                self.x = 0
            end
            if self.y < 0 then
                self.y = love.graphics.getHeight()
            end
            if self.y > love.graphics.getHeight() then
                self.y = 0
            end

            self.distance = self.distance + math.sqrt((self.x_vel ^ 2) + (self.y_vel ^ 2))
        end,

        expload = function (self)
            
            self.expload_time = math.ceil(duration * (love.timer.getFPS()/100))
            if self.expload_time > duration then
                self.exploading = 2
            end
        end
    }
end

return laser
    