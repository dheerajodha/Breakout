ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    -- body
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.highScores = params.highScores
    self.recoverPoints = params.recoverPoints
    self.size = params.size
    self.skin = params.skin
    flagKeyBrick = params.renderKeyBrick
    canDestroy = params.cD
    cd = canDestroy
    self.ball = Ball()
    self.ball.skin = math.random(7)
end

function ServeState:update(dt)
    -- body
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

        gStateMachine:change('play', {
            paddle = self.paddle,
            ball = self.ball,
            health = self.health,
            highScores = self.highScores,
            renderKeyBrick = flagKeyBrick,
            score = self.score,
            bricks = self.bricks,
            level = self.level,
            size = self.size,
            skin = self.skin,
            canDestroy = cd,
            recoverPoints = self.recoverPoints
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ServeState:render()
    -- body
    self.paddle:render()
    self.ball:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level), 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end