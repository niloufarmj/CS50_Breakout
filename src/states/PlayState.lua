PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.paddle = Paddle()

    self.ball = Ball(1)

    -- random speed
    self.ball.dx = math.random(0, 1) == 0 and math.random(-200, -90) or math.random(90, 200)
    self.ball.dy = math.random(-50, -80)

    -- give ball position in the center
    self.ball.x = WINDOW.VIRTUAL_WIDTH / 2 - 4
    self.ball.y = WINDOW.VIRTUAL_HEIGHT - 42

    self.bricks = LevelMaker.createMap()
end

function PlayState:update(dt)
    
    self.paddle:update(dt)
    self.ball:update(dt)
    

    if self.ball:collides(self.paddle) then
        self.ball.y = self.paddle.y - BALL.HEIGHT
        self.ball.dy = -self.ball.dy
    
        local paddleCenter = self.paddle.x + (self.paddle.width / 2)
        local ballCenter = self.ball.x
    
        if (self.ball.x < paddleCenter and self.paddle.dx < 0) or
           (self.ball.x > paddleCenter and self.paddle.dx > 0) then
            self.ball.dx = self.paddle.dx * 50 + (8 * math.abs(paddleCenter - ballCenter))
        end
    
        gSounds['paddle-hit']:play()
    end

    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            brick:hit()
    
            local ballLeft = self.ball.x + 2
            local ballRight = self.ball.x + 6
            local brickLeft = brick.x
            local brickRight = brick.x + brick.width
            local brickTop = brick.y
            local brickBottom = brick.y + 16
    
            if ballRight < brickLeft and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brickLeft - 8
            elseif ballLeft > brickRight and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brickRight
            elseif self.ball.y < brickTop then
                self.ball.dy = -self.ball.dy
                self.ball.y = brickTop - 8
            else
                self.ball.dy = -self.ball.dy
                self.ball.y = brickBottom
            end
    
            self.ball.dy = self.ball.dy * 1.02
            break
        end
    end

end

function PlayState:render()
    
    self.paddle:render()
    self.ball:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

end