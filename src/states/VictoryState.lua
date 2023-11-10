
VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.level = params.level
    self.score = params.score
    self.paddle = params.paddle
    self.health = params.health
    self.ball = params.ball
    self.highScores = params.highScores
end

function VictoryState:update(dt)
    self.paddle:update(dt)

    -- have the ball track the player
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    -- go to play screen if the player presses Enter
    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gStateMachine:change('serve', {
            level = self.level + 1,
            bricks = LevelMaker.createMap(self.level + 1),
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            highScores = self.highScores
        })
    end
end

function VictoryState:render()
    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)

    -- level complete text
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!",
        0, WINDOW.VIRTUAL_HEIGHT / 4, WINDOW.VIRTUAL_WIDTH, 'center')

    -- instructions text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, WINDOW.VIRTUAL_HEIGHT / 2 + 50,
    WINDOW.VIRTUAL_WIDTH, 'center')
end