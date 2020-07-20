PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    -- body
    self.paddle = params.paddle
    self.ball = params.ball
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.highScores = params.highScores
    self.skin = params.skin
    self.size = params.size
    canDestroy = params.canDestroy
    renderKeyBrick = params.renderKeyBrick

    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-60, -50)
    
    self.paused = false

    b1 = Powerup(7)
    b2 = Powerup(7)
    b3 = Powerup(7)

    currentLevelScore = 0

    triggerBalls = Powerup(8)
    triggerBalls.x = VIRTUAL_WIDTH / 2
    triggerBalls.y = VIRTUAL_HEIGHT / 2 - 40

    triggerKey = Powerup(9)
    triggerKey.x = VIRTUAL_WIDTH / 2
    triggerKey.y = VIRTUAL_HEIGHT / 2 - 40

    counter = 0
    multipleBall = false
    flagPowerupBalls = false
    flagPowerupKey = false
    paddleInstantiation = true
    canDestroy = false
    keyBrickDestroyed = false

end

function PlayState:update(dt)
    -- body
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    self.ball:update(dt)
    self.paddle:update(dt)

    if renderKeyBrick == true and flagPowerupKey == true then
        triggerKey.dx = 0
        triggerKey.dy = triggerKey.dy + 1
        triggerKey:update(dt)
    end

    if flagPowerupBalls == true then
        triggerBalls.dx = 0
        triggerBalls.dy = triggerBalls.dy + 1
        triggerBalls:update(dt)
    end

    if triggerBalls:collides(self.paddle) then
        multipleBall = true
        flagPowerupBalls = false
    end

    if triggerKey:collides(self.paddle) then
        flagPowerupKey = false
        canDestroy = true
    end

    if multipleBall == true then
        b1:update(dt)
        b2:update(dt)
        b3:update(dt)
        if b1:collides(self.paddle) then
            collideWithPaddle(b1, self.paddle)
        end
        if b2:collides(self.paddle) then
            collideWithPaddle(b2, self.paddle)
        end
        if b3:collides(self.paddle) then
            collideWithPaddle(b3, self.paddle)
        end
    end
    
    if self.ball:collides(self.paddle) then
        collideWithPaddle(self.ball, self.paddle)    
    end

    for k, brick in pairs(self.bricks) do
        
        if brick.inPlay and self.ball:collides(brick) then

            counter = counter + 1

            if counter == 10 then
                --code to spawn powerup balls
                flagPowerupBalls = true
            end

            if counter == 30 then
                flagPowerupKey = true
            end

            if brick.color == 6 and brick.tier == 3 then
                brick:hit(renderKeyBrick, canDestroy)
                if brick.inPlay == false then
                    keyBrickDestroyed = true
                end
            else
                brick:hit(false, false)
            end      
            
            if renderKeyBrick == true and canDestroy == true then
                self.score = self.score + 2000
                currentLevelScore = currentLevelScore + 2000
            else
                self.score = self.score + (brick.tier * 200 + brick.color * 25)
                currentLevelScore = currentLevelScore + (brick.tier * 200 + brick.color * 25)    
            end
            
            if self:checkVictory() then
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = Paddle(self.skin, 2),
                    health = self.health,
                    score = self.score,
                    ball = self.ball,
                    highScores = self.highScores,
                    recoverPoints = self.recoverPoints,
                    size = 2,
                    skin = self.skin,
                })
            end

            collisionWithBricks(self.ball, brick)

            break
        end

        if brick.inPlay and (b1:collides(brick) or b2:collides(brick) or b3:collides(brick)) 
                and multipleBall == true then

            self.score = self.score + (brick.tier * 200 + brick.color * 25)
            currentLevelScore = currentLevelScore + (brick.tier * 200 + brick.color * 25)
            
            if brick.color == 6 and brick.tier == 3 then
                brick:hit(renderKeyBrick, canDestroy)
            else
                brick:hit(false, false)
            end            

            if self:checkVictory() then
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    ball = self.ball,
                    highScores = self.highScores,
                    recoverPoints = self.recoverPoints,
                    skin = self.skin,
                    size = self.size
                })
            end
            
            if multipleBall == true then
                if b1:collides(brick) then
                    collisionWithBricks(b1, brick)
                end
                if b2:collides(brick) then
                    collisionWithBricks(b2, brick)
                end
                if b3:collides(brick) then
                    collisionWithBricks(b3, brick)
                end
            end

            break
        end
    end

    if currentLevelScore > 500 and currentLevelScore < 1000 then
        if paddleInstantiation and self.paddle.size < 4 then
            self.paddle = Paddle(self.skin, self.paddle.size + 1)
            self.size = self.size + 1
            paddleInstantiation = false
        end
    elseif currentLevelScore >= 1000 then
        if paddleInstantiation == false and self.paddle.size < 4 then
            self.paddle = Paddle(self.skin, self.paddle.size + 1)
            self.size = self.size + 1
            paddleInstantiation = true
        end
    end

    if (b1.y >= VIRTUAL_HEIGHT and b2.y >= VIRTUAL_HEIGHT and b3.y >= VIRTUAL_HEIGHT) then
        multipleBall = false
    end

    if triggerKey.y >= VIRTUAL_HEIGHT then
        flagPowerupKey = false
    end

    if self.ball.y >= VIRTUAL_HEIGHT then

        if self.health > 1 and self.paddle.size > 2 then
            self.paddle = Paddle(self.skin, self.paddle.size - 1)
            self.size = self.size - 1
        end

        self.health = self.health - 1

        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores,
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                level = self.level,
                highScores = self.highScores,
                recoverPoints = self.recoverPoints,
                size = self.size - 1,
                skin = self.skin,
                cD = canDestroy
            })
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function collisionWithBricks(b, brick)
    -- body
    if b.x + 2 < brick.x and b.dx > 0 then

        b.dx = -b.dx
        b.x = brick.x - b.width
    
    elseif b.x + 6 > brick.x and b.dx < 0 then

        b.dx = -b.dx
        b.x = brick.x + 32

    elseif b.y < brick.y then

        b.dy = -b.dy
        b.y = brick.y - b.height 

    else

        b.dy = -b.dy
        b.y = brick.y + b.height

    end

    b.dy = b.dy * 1.02
end

function collideWithPaddle(b, p)
    -- body
    b.dy = -b.dy
    b.y = p.y - 8

    if b.x < p.x + (p.width / 2) and p.dx < 0 then
        b.dx = -50 + -(8 * ((p.x + p.width / 2) - b.x))
    
    elseif b.x > (p.x + p.width / 2) and b.dx > 0 then
        b.dx = 50 + (8 * math.abs(p.x + p.width / 2 - b.x))
    end 
    
    gSounds['paddle-hit']:play()
end

function PlayState:render()
    -- body

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    if multipleBall == true then
        b1:render()
        b2:render()
        b3:render()
    end

    if renderKeyBrick == true and flagPowerupKey == true and keyBrickDestroyed == false then
        triggerKey:render()
    end

    if flagPowerupBalls == true then
        triggerBalls:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    self.ball:render()

    renderScore(self.score)
    renderHealth(self.health)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('PAUSED', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end

    return true
end