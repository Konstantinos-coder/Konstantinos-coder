require "globals"

local love = require "love"
local laser = require "objects/laser"


function player(num_lives)
    local ship_size  = 30
    local expload_duration = 3
    local view_angle = math.rad(90)
    local laser_distance = 0.6
    local max_lasers = 10

    return{
        x = love.graphics.getWidth()/2,
        y = love.graphics.getHeight()/2,
        lasers = {},
        radius = ship_size/2,
        angle = view_angle,
        rotation = 0,
        expload_time = 0,
        exploading = false,
        thrusting = false,
        thrust = {
            x = 0,
            y = 0,
            speed = 5,
            FLAME = false,
            flame = 2.0
        },
        lives = num_lives or 1,
        
        draw_flame = function(self, fillType, color)
            love.graphics.setColor(color)

            love.graphics.polygon(
                fillType,
                self.x - self.radius * (2/3 * math.cos(self.angle) + 0.5 * math.sin(self.angle)),
                self.y + self.radius * (2/3 * math.sin(self.angle) - 0.5 * math.cos(self.angle)),
                self.x - self.radius * self.thrust.flame * math.cos(self.angle),
                self.y + self.radius * self.thrust.flame * math.sin(self.angle),
                self.x - self.radius * (2/3 * math.cos(self.angle) - 0.5 * math.sin(self.angle)),
                self.y + self.radius * (2/3 * math.sin(self.angle) + 0.5 * math.cos(self.angle))
            )

            --for _,laser in lasers do
            --    laser:draw(faded)
            --end
        end,

        shoot = function(self)
            if #self.lasers < max_lasers then
                table.insert( self.lasers, laser(self.x, self.y, self.angle))
            end
        end,

        destroy = function(self, index)
            table.remove( self.lasers, index)
        end,

        draw = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            if not self.exploading then
                if self.thrusting then
                    --if not self.thrusting.FlAME then
                    --    self.thrust.flame = self.thrust.flame -1 / love.timer.getFPS()
                    --end
                    self:draw_flame("fill", {1, 0.4, 0.1})
                    self:draw_flame("line", {1, 0.16, 0})
                end
                if show_debugging then
                    love.graphics.setColor(1, 0, 0)
                    love.graphics.rectangle("fill", (self.x) - 1, self.y - 1, 2, 2)
                    love.graphics.circle("line", (self.x), self.y, self.radius)
                end
    
                love.graphics.setColor(2, 2, 2, opacity)
    
                love.graphics.polygon(
                    "line",
                    self.x + ((4/3) * self.radius) * math.cos(self.angle),
                    self.y - ((4/3) * self.radius) * math.sin(self.angle),
                    self.x - self.radius * (2/3 * math.cos(self.angle) + math.sin(self.angle)),
                    self.y + self.radius * (2/3 * math.sin(self.angle) - math.cos(self.angle)),
                    self.x - self.radius * (2/3 * math.cos(self.angle) - math.sin(self.angle)),
                    self.y + self.radius * (2/3 * math.sin(self.angle) + math.cos(self.angle))
                )
    
                for _,laser in pairs(self.lasers) do
                    laser:draw(faded)
                end
            else
                love.graphics.setColor(1, 0, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius * 1.5)
                love.graphics.setColor(1, 0.62, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius)
                love.graphics.setColor(1, 0.92, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius * 0.5)
            end

            --[[if show_debugging then
                love.graphics.setColor(1, 0, 0)
                love.graphics.rectangle("fill", (i*pos_x) - 1, pos_y - 1, 2, 2)
                love.graphics.circle("line", (i*pos_x), pos_y, self.radius)
            end

            love.graphics.setColor(2, 2, 2, opacity)

            love.graphics.polygon(
                "line",
                (i*pos_x) + ((4/3) * self.radius) * math.cos(self.angle),
                pos_y - ((4/3) * self.radius) * math.sin(self.angle),
                (i*pos_x) - self.radius * (2/3 * math.cos(self.angle) + math.sin(self.angle)),
                pos_y + self.radius * (2/3 * math.sin(self.angle) - math.cos(self.angle)),
                (i*pos_x) - self.radius * (2/3 * math.cos(self.angle) - math.sin(self.angle)),
                pos_y + self.radius * (2/3 * math.sin(self.angle) + math.cos(self.angle))
            )]]

            for _,laser in pairs(self.lasers) do
                laser:draw(faded)
            end
        end,

        draw_lives = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            if self.lives == 2 then
                love.graphics.setColor(1, 1, 0.5, opacity)
            elseif self.lives == 1 then
                love.graphics.setColor(1, 0.1, 0.1, opacity)
            else 
                love.graphics.setColor(1, 1, 1, opacity)
            end

            local pos_x, pos_y = 45, 30
            
            for i=1, self.lives do
                if self.exploading then
                    if i == self.lives then
                        love.graphics.setColor(1, 0, 0, opacity)
                    end
                end
                
                love.graphics.polygon(
                    "line",
                    (i*pos_x) + ((4/3) * self.radius) * math.cos(view_angle),
                    pos_y - ((4/3) * self.radius) * math.sin(view_angle),
                    (i*pos_x) - self.radius * (2/3 * math.cos(view_angle) + math.sin(view_angle)),
                    pos_y + self.radius * (2/3 * math.sin(view_angle) - math.cos(view_angle)),
                    (i*pos_x) - self.radius * (2/3 * math.cos(view_angle) - math.sin(view_angle)),
                    pos_y + self.radius * (2/3 * math.sin(view_angle) + math.cos(view_angle))
                ) 
            end
    
        end,
        
        move = function(self)
            self.exploading = self.expload_time > 0  

            if not self.exploading then
                local fps = love.timer.getFPS()
                local friction = 0.7
                self.rotation = 360 / 180 * math.pi/ fps
                if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
                    self.angle = self.angle +self.rotation
                end
                if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
                    self.angle = self.angle -self.rotation
                end
                if self.thrusting then
                    self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.angle) / fps
                    self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.angle) / fps
                else
                    if self.thrust.x ~= 0 or self.thrust.y ~= 0 then
                        self.thrust.x = self.thrust.x - friction* self.thrust.x/fps
                        self.thrust.y = self.thrust.y - friction* self.thrust.y/fps
                    end
                end
                self.x = self.x + self.thrust.x
                self.y = self.y + self.thrust.y

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

                
            end

            for index, laser in pairs(self.lasers) do

                if (laser.distance > laser_distance * love.graphics.getWidth()) and (laser.exploading == 0) then
                    laser:expload()
                end

                if laser.exploading == 0 then
                    laser:move()
                elseif laser.exploading == 2 then
                    self.destroy(self, index)
                end               
            end
        end,

        expload = function(self)
            self.expload_time = math.ceil(expload_duration * love.timer.getFPS())
        end
    }

end

return player