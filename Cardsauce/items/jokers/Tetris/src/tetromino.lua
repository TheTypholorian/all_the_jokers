Tetromino = {}

Tetromino.shapes = {
    I = {
        {{0, 0, 0, 0}, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 0, 0, 0}}, -- 0 degrees
        {{0, 1, 0, 0}, {0, 1, 0, 0}, {0, 1, 0, 0}, {0, 1, 0, 0}}, -- 90 degrees
        {{0, 0, 0, 0}, {0, 0, 0, 0}, {1, 1, 1, 1}, {0, 0, 0, 0}}, -- 180 degrees
        {{0, 0, 1, 0}, {0, 0, 1, 0}, {0, 0, 1, 0}, {0, 0, 1, 0}}, -- 270 degrees
    },
    T = {
        {{0, 1, 0}, {1, 1, 1}, {0, 0, 0}}, -- 0 degrees
        {{0, 1, 0}, {0, 1, 1}, {0, 1, 0}}, -- 90 degrees
        {{0, 0, 0}, {1, 1, 1}, {0, 1, 0}}, -- 180 degrees
        {{0, 1, 0}, {1, 1, 0}, {0, 1, 0}}, -- 270 degrees
    },
    J = {
        {{1, 0, 0}, {1, 1, 1}, {0, 0, 0}}, -- 0 degrees
        {{0, 1, 1}, {0, 1, 0}, {0, 1, 0}}, -- 90 degrees
        {{0, 0, 0}, {1, 1, 1}, {0, 0, 1}}, -- 180 degrees
        {{0, 1, 0}, {0, 1, 0}, {1, 1, 0}}, -- 270 degrees
    },
    L = {
        {{0, 0, 1}, {1, 1, 1}, {0, 0, 0}}, -- 0 degrees
        {{0, 1, 0}, {0, 1, 0}, {0, 1, 1}}, -- 90 degrees
        {{0, 0, 0}, {1, 1, 1}, {1, 0, 0}}, -- 180 degrees
        {{1, 1, 0}, {0, 1, 0}, {0, 1, 0}}, -- 270 degrees
    },
    S = {
        {{0, 1, 1}, {1, 1, 0}, {0, 0, 0}}, -- 0 degrees
        {{0, 1, 0}, {0, 1, 1}, {0, 0, 1}}, -- 90 degrees
        {{0, 0, 0}, {0, 1, 1}, {1, 1, 0}}, -- 180 degrees
        {{1, 0, 0}, {1, 1, 0}, {0, 1, 0}}, -- 270 degrees
    },
    Z = {
        {{1, 1, 0}, {0, 1, 1}, {0, 0, 0}}, -- 0 degrees
        {{0, 0, 1}, {0, 1, 1}, {0, 1, 0}}, -- 90 degrees
        {{0, 0, 0}, {1, 1, 0}, {0, 1, 1}}, -- 180 degrees
        {{0, 1, 0}, {1, 1, 0}, {1, 0, 0}}, -- 270 degrees
    },
    O = {
        {{1, 1}, {1, 1}},
    },
}

Tetromino.wallKicks = {
    I = {
        [0] = {{0, 0}, {-2, 0}, {1, 0}, {-2, -1}, {1, 2}}, -- From 0 to 90
        [1] = {{0, 0}, {-1, 0}, {2, 0}, {-1, 2}, {2, -1}}, -- From 90 to 180
        [2] = {{0, 0}, {2, 0}, {-1, 0}, {2, 1}, {-1, -2}}, -- From 180 to 270
        [3] = {{0, 0}, {1, 0}, {-2, 0}, {1, -2}, {-2, 1}}, -- From 270 to 0
    },
    J = {
        [0] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}, -- From 0 to 90
        [1] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, -- From 90 to 180
        [2] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}, -- From 180 to 270
        [3] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}, -- From 270 to 0
    },
    L = {
        [0] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}, -- From 0 to 90
        [1] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, -- From 90 to 180
        [2] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}, -- From 180 to 270
        [3] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}, -- From 270 to 0
    },
    S = {
        [0] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}, -- From 0 to 90
        [1] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, -- From 90 to 180
        [2] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}, -- From 180 to 270
        [3] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}, -- From 270 to 0
    },
    T = {
        [0] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}, -- From 0 to 90
        [1] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, -- From 90 to 180
        [2] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}, -- From 180 to 270
        [3] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}, -- From 270 to 0
    },
    Z = {
        [0] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}, -- From 0 to 90
        [1] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, -- From 90 to 180
        [2] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}, -- From 180 to 270
        [3] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}, -- From 270 to 0
    },
}

Tetromino.colors = {
    I = HEX('ebf6f8'), -- White Stake
    O = HEX('f2c255'), -- Yellow Stake
    T = HEX('8a71e1'), -- Purple Stake
    J = HEX('009cfd'), -- Blue Stake
    L = HEX('e47c4c'), -- Orange Stake
    S = HEX('55a383'), -- Green Stake
    Z = HEX('fd5f55'), -- Red Stake
}

function Tetromino:new(tetromino, x, y, rotation)
    rotation = rotation or 0
    local obj = {
        type = tetromino,
        shape = Tetromino.shapes[tetromino][1],
        x = x,
        y = y,
        rotation = rotation
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Tetromino:rotate(clockwise)
    if self.type == "O" then return end
    local currentRotation = self.rotation or 0
    local newRotation = (currentRotation + (clockwise and 1 or -1)) % 4
    local originalX, originalY = self.x, self.y
    local originalShape = self.shape

    local kicks = Tetromino.wallKicks[self.type][currentRotation]

    for _, kick in ipairs(kicks) do
        self.x = originalX + kick[1]
        self.y = originalY + kick[2]
        self.shape = Tetromino.shapes[self.type][newRotation + 1]

        if not self.board:checkCollision(self) then
            self.rotation = newRotation
            Tetris:updateGhostTetromino()
            return
        end
    end

    self.x = originalX
    self.y = originalY
    self.shape = originalShape
end

function Tetromino:draw(x_offset, y_offset)
    x_offset = x_offset or 0
    y_offset = y_offset or 0
    for row = 1, #self.shape do
        for col = 1, #self.shape[row] do
            if self.shape[row][col] == 1 then
                local screenX = (self.x + col - 2) * Tetris.blockSize + Tetris.gridOffsetX + x_offset -- Adjusted to start from 0
                local screenY = (self.y + row - 2) * Tetris.blockSize + Tetris.gridOffsetY + y_offset-- Adjusted to start from 0
                love.graphics.rectangle("fill", screenX, screenY, Tetris.blockSize, Tetris.blockSize)
            end
        end
    end
end

return Tetromino