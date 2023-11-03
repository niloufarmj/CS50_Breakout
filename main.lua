require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Breakout')

    -- initialize fonts
    gFonts = {
        ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts['small'])

    -- load up the graphics
    gTextures = {
        ['background'] = love.graphics.newImage('assets/graphics/background.jpg'),
        ['main'] = love.graphics.newImage('assets/graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('assets/graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('assets/graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('assets/graphics/particle.png')
    }
    
    push:setupScreen(WINDOW.VIRTUAL_WIDTH, WINDOW.VIRTUAL_HEIGHT, WINDOW.WIDTH, WINDOW.HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gSounds = {
        ['paddle-hit'] = love.audio.newSource('assets/sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('assets/sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('assets/sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('assets/sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('assets/sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('assets/sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('assets/sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('assets/sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('assets/sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('assets/sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('assets/sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('assets/sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('assets/sounds/pause.wav', 'static'),

        ['music'] = love.audio.newSource('assets/sounds/music.wav', 'static')
    }

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end
    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end


function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    -- we no longer have this globally, so include here
    if key == 'escape' then
        love.event.quit()
    end
end


function love.draw()
    push:apply('start')

    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    local scaleX = WINDOW.VIRTUAL_WIDTH / backgroundWidth
    local scaleY = WINDOW.VIRTUAL_HEIGHT / backgroundHeight

    love.graphics.draw(gTextures['background'], 0, 0, 0, scaleX, scaleY)

    gStateMachine:render()
    
    displayFPS()
    
    push:apply('end')
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end