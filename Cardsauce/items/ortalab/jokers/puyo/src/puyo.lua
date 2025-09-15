local Puyo = {}
Puyo.__index = Puyo

Puyo.SIZE = 5
Puyo.FALL_SPEED = 20

function Puyo.new(x, y, quad, sprite)
    local self = setmetatable({}, Puyo)
    self.x = x
    self.y = y
    self.quad = quad
    self.sprite = sprite
    self.sprite = sprite
    return self
end

function Puyo:setQuad(newQuad)
    self.quad = newQuad
end

function Puyo:update(dt)
    self.y = self.y + Puyo.FALL_SPEED * dt
end

function Puyo:draw(x_offset, y_offset)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite, self.quad, self.x + x_offset, self.y + y_offset)
end

return Puyo