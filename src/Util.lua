
function GenerateQuads(atlas, tilewidth, tileheight)
    -- body
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] = love.graphics.newQuad(x * tilewidth, y * tileheight, 
                                    tilewidth, tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced+1] = tbl[i]
    end

    return sliced
end

function GenerateQuadsBricks(atlas)
    return table.slice(GenerateQuads(atlas, 32, 16), 1, 25)
end

function GenerateQuadsPaddles(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0,3 do
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
        counter = counter + 1

        x = 0
        y = y + 32
    end

    return quads
end

function GenerateQuadsBalls(atlas)
    local x = 96
    local y = 48

    local counter = 1
    local quads = {}

    quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
    counter = counter + 1

    quads[counter] = love.graphics.newQuad(x + 8, y, 8, 8, atlas:getDimensions())
    counter = counter + 1

    quads[counter] = love.graphics.newQuad(x + 16, y, 8, 8, atlas:getDimensions())
    counter = counter + 1

    quads[counter] = love.graphics.newQuad(x + 24, y, 8, 8, atlas:getDimensions())
    counter = counter + 1

    quads[counter] = love.graphics.newQuad(x + 8, y + 8, 8, 8, atlas:getDimensions())
    counter = counter + 1

    quads[counter] = love.graphics.newQuad(x + 16, y + 8, 8, 8, atlas:getDimensions())
    counter = counter + 1

    --powerup ball
    quads[counter] = love.graphics.newQuad(x, y + 8, 8, 8, atlas:getDimensions())
    counter = counter + 1

    --trigger of powerup ball
    quads[counter] = love.graphics.newQuad(x - 32, y + 144, 16, 16, atlas:getDimensions())
    counter = counter + 1

    --key ball
    quads[counter] = love.graphics.newQuad(x + 48, y + 144, 16, 16, atlas:getDimensions())

    return quads
end