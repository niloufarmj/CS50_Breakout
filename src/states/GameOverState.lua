GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score
end

function GameOverState:update(dt)
    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gStateMachine:change('start')
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
end