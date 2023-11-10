Paddle = Class{}

function Paddle:init(skin)
    -- x is placed in the middle
    self.x = WINDOW.VIRTUAL_WIDTH / 2 - 32

    -- y is placed a little above the bottom edge of the screen
    self.y = WINDOW.VIRTUAL_HEIGHT - 32

    self.dx = 0

    self.width = 64
    self.height = PADDLE.HEIGHT

    self.skin = skin
    self.size = 2
end

function Paddle:update(dt)
    -- keyboard input
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE.SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE.SPEED
    else
        self.dx = 0
    end

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(WINDOW.VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)],
        self.x, self.y)
end