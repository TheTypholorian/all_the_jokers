local Board = {}


Board.colors = {
    grid_edge = HEX('bfc7d5'),
    grid_shadow = HEX('4f6367'),
    background = HEX('2d433c')
}

function Board:new(id, width, height, x, y, block_scale)
    local obj = {id = id, grid = {}, width = width, height = height, x = x, y = y, scale = block_scale}
    for _y = 1, height do
        obj.grid[_y] = {}
        for _x = 1, width do
            obj.grid[_y][_x] = 0
        end
    end
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Board:checkCollision(tetromino)
    if self.id == 'main' then
        for row = 1, #tetromino.shape do
            for col = 1, #tetromino.shape[row] do
                if tetromino.shape[row][col] == 1 then
                    local boardX = tetromino.x + col - 1
                    local boardY = tetromino.y + row - 1

                    if boardX < 1 or boardX > self.width then
                        return true
                    end

                    if boardY > 0 then
                        if boardY > self.height or self.grid[boardY][boardX] ~= 0 then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function Board:lockTetromino(tetromino)
    if self.id == 'main' then
        for row = 1, #tetromino.shape do
            for col = 1, #tetromino.shape[row] do
                if tetromino.shape[row][col] == 1 then
                    local boardX = tetromino.x + col - 1
                    local boardY = tetromino.y + row - 1

                    if boardX >= 1 and boardX <= self.width and boardY >= 1 and boardY <= self.height then
                        self.grid[boardY][boardX] = Tetromino.colors[tetromino.type]
                    end
                end
            end
        end
    end
end

function Board:getClearedRows()
    local rowsCleared = 0
    local fullRows = {}

    for y = self.height, 1, -1 do
        local fullRow = true
        for x = 1, self.width do
            if self.grid[y][x] == 0 then
                fullRow = false
                break
            end
        end
        if fullRow then
            fullRows[#fullRows+1] = y
            rowsCleared = rowsCleared + 1
        end
    end

    return rowsCleared, fullRows
end

function Board:clearRows()
    local totalRowsCleared = 0
    local rowsCleared

    repeat
        rowsCleared = 0
        for y = self.height, 1, -1 do
            local fullRow = true
            for x = 1, self.width do
                if self.grid[y][x] == 0 then
                    fullRow = false
                    break
                end
            end
            if fullRow then
                for row = y, 2, -1 do
                    self.grid[row] = self.grid[row - 1]
                end
                self.grid[1] = {}
                for x = 1, self.width do
                    self.grid[1][x] = 0
                end
                rowsCleared = rowsCleared + 1
                totalRowsCleared = totalRowsCleared + 1
                break
            end
        end
    until rowsCleared == 0

    return totalRowsCleared
end

function Board:draw(x_offset, y_offset)
    x_offset = x_offset or 0
    y_offset = y_offset or 0
    if self.id == 'main' then
        love.graphics.setColor(Board.colors.background)
        love.graphics.rectangle("fill", Tetris.gridOffsetX + x_offset, Tetris.gridOffsetY + y_offset, self.width * Tetris.blockSize, self.height * Tetris.blockSize)

        if not Tetris.gameOverAnimationState or Tetris.gameOverAnimationState ~= 'decreasing' then
            for y = 1, self.height do
                for x = 1, self.width do
                    local screenX = (x - 1) * Tetris.blockSize + Tetris.gridOffsetX + x_offset
                    local screenY = (y - 1) * Tetris.blockSize + Tetris.gridOffsetY + y_offset

                    if self.grid[y][x] ~= 0 then
                        local color = self.grid[y][x]
                        love.graphics.setColor(color[1], color[2], color[3])
                        love.graphics.rectangle("fill", screenX, screenY, Tetris.blockSize, Tetris.blockSize)
                    end
                end
            end
        end

        love.graphics.setColor(Board.colors.grid_edge)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", Tetris.gridOffsetX + x_offset - 0.5, Tetris.gridOffsetY + y_offset - 0.5, (self.width * Tetris.blockSize) + 1, (self.height * Tetris.blockSize) + 1)

        love.graphics.setColor(1, 1, 1)
    elseif self.id == 'mult' or self.id == 'speed' then
        love.graphics.setColor(Board.colors.background)
        love.graphics.rectangle("fill", self.x + x_offset, self.y + y_offset, self.width * self.scale, self.height * self.scale)

        for y = 1, self.height do
            for x = 1, self.width do
                local screenX = (x - 1) * self.scale + self.x + x_offset
                local screenY = (y - 1) * self.scale + self.y + y_offset

                if self.grid[y][x] ~= 0 then
                    local color = self.grid[y][x]
                    love.graphics.setColor(color[1], color[2], color[3])
                    love.graphics.rectangle("fill", screenX, screenY, self.scale, self.scale)
                end
            end
        end
        love.graphics.setColor(Board.colors.grid_edge)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", self.x + x_offset - 0.5, self.y + y_offset - 0.5, (self.width * self.scale) + 1, (self.height * self.scale) + 1)

        love.graphics.setColor(1, 1, 1)
    end
end

return Board