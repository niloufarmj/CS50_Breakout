
StartState = Class{__includes = BaseState}

-- whether we're highlighting "Start" or "High Scores"
local highlighted = 1

function StartState:update(dt)
    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.keysPressed['up'] or love.keyboard.keysPressed['down'] then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end

    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gSounds['confirm']:play()

        if highlighted == 1 then
            gStateMachine:change('serve', {
                paddle = Paddle(1),
                bricks = LevelMaker.createMap(),
                health = 3,
                score = 0
            })
        end
    end

end

function StartState:render()
    -- title
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("BREAKOUT", 0, WINDOW.VIRTUAL_HEIGHT / 3,
        WINDOW.VIRTUAL_WIDTH, 'center')
    
    -- instructions
    love.graphics.setFont(gFonts['medium'])

    local optionY = WINDOW.VIRTUAL_HEIGHT / 2 + 70

    -- Draw option 1
    if highlighted == 1 then
        love.graphics.setColor(70/255, 200/255, 1, 1)
    end
    love.graphics.printf("START", 0, optionY, WINDOW.VIRTUAL_WIDTH, 'center')

    -- Reset the color
    love.graphics.setColor(1, 1, 1, 1)

    optionY = optionY + 20

    -- Draw option 2
    if highlighted == 2 then
        love.graphics.setColor(70/255, 200/255, 1, 1)
    end
    love.graphics.printf("HIGH SCORES", 0, optionY, WINDOW.VIRTUAL_WIDTH, 'center')

    -- Reset the color
    love.graphics.setColor(1, 1, 1, 1)
end