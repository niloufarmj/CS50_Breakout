Ball = Class{}

function Ball:init(skin)
    -- simple positional and dimensional variables
    self.width = BALL.WIDTH
    self.height = BALL.HEIGHT

    self.dy = 0
    self.dx = 0

    self.skin = skin
end



function Ball:reset()
    self.x = WINDOW.VIRTUAL_WIDTH / 2 - 2
    self.y = WINDOW.VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- allow ball to bounce off walls
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.x >= WINDOW.VIRTUAL_WIDTH - 8 then
        self.x = WINDOW.VIRTUAL_WIDTH - 8
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        gSounds['wall-hit']:play()
    end
end

function Ball:collides(target)
    return not (self.x > target.x + target.width or target.x > self.x + self.width) and 
            not (self.y > target.y + target.height or target.y > self.y + self.height)

end

function Ball:render()
    -- gTexture is our global texture for all blocks
    -- gBallFrames is a table of quads mapping to each individual ball skin in the texture
    love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin],
        self.x, self.y)
end