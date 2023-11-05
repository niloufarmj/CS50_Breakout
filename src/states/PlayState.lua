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
end

function PlayState:update(dt)
    
    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then
        self.ball.dy = -self.ball.dy
        gSounds['paddle-hit']:play()
    end

end

function PlayState:render()
    
    self.paddle:render()
    self.ball:render()

end