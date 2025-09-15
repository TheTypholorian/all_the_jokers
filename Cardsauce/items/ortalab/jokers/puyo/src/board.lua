local Board = {}
Board.__index = Board

function Board.new(x, y, width, height)
    local self = setmetatable({}, Board)
    self.x = x or 14
    self.y = y or 0
    self.width = width or 32
    self.height = height or 62
    return self
end

function Board:draw(x_offset, y_offset)
    love.graphics.setColor(PuyoPuyo.colors.edges)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", self.x + 0.5 + x_offset, self.y + 0.5 + y_offset, self.width - 1, self.height - 1)
    love.graphics.setColor(1, 1, 1, 1)
end

return Board