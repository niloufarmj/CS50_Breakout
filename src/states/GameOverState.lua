GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score
    self.highScores = params.highScores

end

function GameOverState:update(dt)
    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        local highScore = false
        
        -- keep track of what high score ours overwrites, if any
        local scoreIndex = 11

        for i = 10, 1, -1 do
            local score = self.highScores[i].score or 0
            if self.score > score then
                highScoreIndex = i
                highScore = true
            end
        end

        if highScore then
            gSounds['high-score']:play()
            gStateMachine:change('enter-high-score', {
                highScores = self.highScores,
                score = self.score,
                scoreIndex = highScoreIndex
            }) 
        else 
            gStateMachine:change('start', {
                highScores = self.highScores
            }) 
        end
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('GAME OVER', 0, WINDOW.VIRTUAL_HEIGHT / 3, WINDOW.VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, WINDOW.VIRTUAL_HEIGHT / 2,
    WINDOW.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter!', 0, WINDOW.VIRTUAL_HEIGHT - WINDOW.VIRTUAL_HEIGHT / 4,
    WINDOW.VIRTUAL_WIDTH, 'center')

    if self.highScores == nil then
        love.graphics.printf('high score is nil :(', 0, WINDOW.VIRTUAL_HEIGHT / 2,
        WINDOW.VIRTUAL_WIDTH, 'center')
    end
end