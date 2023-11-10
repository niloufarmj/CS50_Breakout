PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = params.ball
    self.level = params.level

    -- give ball random starting velocity
    self.ball.dx = math.random(0, 1) == 0 and math.random(-200, -90) or math.random(90, 200)
    self.ball.dy = math.random(-50, -80)
end


function PlayState:update(dt)
    
    self.paddle:update(dt)
    self.ball:update(dt)
    

    if self.ball:collides(self.paddle) then
        -- raise ball above paddle in case it goes below it, then reverse dy
        self.ball.y = self.paddle.y - 8
        self.ball.dy = -self.ball.dy

        -- if we hit the paddle on its left side while moving left...
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
        
        -- else if we hit the paddle on its right side while moving right...
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end

        gSounds['paddle-hit']:play()
    end

    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then

            self.score = self.score + (brick.tier * 200 + brick.color * 25)

            brick:hit()

            if self:checkVictory() then
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    ball = self.ball
                })
            end
    
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

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    if self.ball.y >= WINDOW.VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                level = self.level
            })
        end
    end

end

function PlayState:render()
    
    self.paddle:render()
    self.ball:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    renderScore(self.score)
    renderHealth(self.health)

end

function PlayState:checkVictory()
    for _, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end
    return true
end