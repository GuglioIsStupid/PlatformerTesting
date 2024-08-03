local Camera = Object:extend()

function Camera:new(x, y, width, height)
    self.x = x or 0
    self.y = y or 0
    self.width = width or love.graphics.getWidth()
    self.height = height or love.graphics.getHeight()
    
    return self
end

function Camera:set()
    love.graphics.push()
    love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Camera:setPosition(x, y)
    self.x = x
    self.y = y
end

function Camera:isOnScreen(object)
    return object.x + object.w > self.x and object.x < self.x + self.width
       and object.y + object.h > self.y and object.y < self.y + self.height
end

return Camera