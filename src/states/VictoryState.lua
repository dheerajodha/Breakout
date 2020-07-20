VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    -- body
    self.level = params.level
    self.score = params.score
    self.paddle = params.paddle
    self.highScores = params.highScores
    self.recoverPoints = params.recoverPoints
    self.health = params.health
    self.ball = params.ball
    self.size = params.size
    self.skin = params.skin

    flagKeyBrick = math.random(3) % 2 == 0 and true or false
end

function VictoryState:update(dt)
    -- body
    self.paddle:update(dt)

    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            level = self.level + 1,
            bricks = LevelMaker.createMap(self.level + 1, flagKeyBrick),
            renderKeyBrick = flagKeyBrick,
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            highScores = self.highScores,
            recoverPoints = self.recoverPoints,
            skin = self.skin,
            size = 2
        })
    end
end

function VictoryState:render()
    -- body
    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level) .. ' Complete!',
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

end