local Player = Object:extend()

function Player:new()
    self.x = 100
    self.y = 100
    self.w = 16
    self.h = 32
    self.speed = 100
    self.gravity = 450
    self.jumpForce = -125
    self.maxJumpTime = 0.3
    self.jumpTime = 0
    self.isJumping = false
    self.isFalling = true
    self.yVelocity = 0
    self.moveDirection = 0
end

function Player:update(dt)
    if self.isFalling then
        self.yVelocity = self.yVelocity + self.gravity * dt
    end

    self.moveDirection = 0
    if love.keyboard.isDown("right") then
        self.moveDirection = 1
    elseif love.keyboard.isDown("left") then
        self.moveDirection = -1
    end
    self.x = self.x + self.speed * dt * self.moveDirection

    if love.keyboard.isDown("space") then
        if not self.isFalling then
            self.isJumping = true
            self.isFalling = true
            self.yVelocity = self.jumpForce
            self.jumpTime = self.jumpTime + dt
        elseif self.isJumping and self.jumpTime < self.maxJumpTime then
            self.yVelocity = self.jumpForce / (1 + self.jumpTime)
            self.jumpTime = self.jumpTime + dt
        end
    else
        self.isJumping = false
    end

    self.y = self.y + self.yVelocity * dt

    self.isFalling = true
end

function Player:checkCollision(collision)
    local tag = collision.tag or "normal" -- Default to "normal" if no tag

    if AABBbox(self, collision) then
        if self.yVelocity > 0 and self.y + self.h <= collision.y + 5 then
            self.y = collision.y - self.h
            self.yVelocity = 0
            self.isFalling = false
            self.jumpTime = 0
        elseif tag == "normal" then
            if self.yVelocity < 0 and self.y >= collision.y + collision.h - 5 then
                self.y = collision.y + collision.h
                self.yVelocity = 0
            elseif self.moveDirection == 1 and self.x + self.w <= collision.x + 5 then
                self.x = collision.x - self.w
            elseif self.moveDirection == -1 and self.x >= collision.x + collision.w - 5 then
                self.x = collision.x + collision.w
            end
        end
    end
end

function Player:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return Player