
WINDOW = {
    WIDTH = 1100,
    HEIGHT = 620,
    VIRTUAL_WIDTH = 460,
    VIRTUAL_HEIGHT = 260
}

PADDLE = {
    SPEED = 200,
    HEIGHT = 16
}

BALL = {
    WIDTH = 8, 
    HEIGHT = 8
}

function renderHealth(health)
    -- start of our health rendering
    local healthX = WINDOW.VIRTUAL_WIDTH - 120
    
    -- render health left
    for i = 1, health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end

    -- render missing health
    for i = 1, 3 - health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end
end

function renderScore(score)
    love.graphics.setFont(gFonts['score'])
    love.graphics.print('SCORE: ' .. tostring(score), WINDOW.VIRTUAL_WIDTH - 70, 3)
end