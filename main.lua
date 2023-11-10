require 'src/Dependencies'

local paused = false

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Breakout')

    -- initialize fonts
    gFonts = {
        ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32),
        ['score'] = love.graphics.newFont('assets/fonts/score-font.ttf', 12)
    }
    love.graphics.setFont(gFonts['small'])

    -- load up the graphics
    gTextures = {
        ['background'] = love.graphics.newImage('assets/graphics/background.png'),
        ['main'] = love.graphics.newImage('assets/graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('assets/graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('assets/graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('assets/graphics/particle.png')
    }

    gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9)
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
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function () return ServeState() end,
        ['game-over'] = function () return GameOverState() end,
        ['victory'] = function () return VictoryState() end,
        ['high-scores'] = function() return HighScoreState() end,
        ['enter-high-score'] = function() return EnterHighScoreState() end
    }

    gStateMachine:change('start', {highScores = loadHighScores()})

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if not paused then 
        gStateMachine:update(dt)
    end

    love.keyboard.keysPressed = {}
end


function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end

    if key == 'p' and gStateMachine.currentName == 'play' then 
        paused = not paused
        if paused then
            gSounds['pause']:play()
        end
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

function loadHighScores()
    love.filesystem.setIdentity('breakout')

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.getInfo('breakout.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'CTO\n'
            scores = scores .. tostring(i * 1000) .. '\n'
        end

        love.filesystem.write('breakout.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('breakout.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores
end