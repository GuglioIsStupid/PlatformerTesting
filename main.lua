local player = {
    x = 100,
    y = 100,
    width = 16,
    height = 32,
    speed = 100,
    gravity = 450,
    jumpForce = -125,
    maxJumpTime = 0.3,
    jumpTime = 0,
    isJumping = false,
    isFalling = true,
    yVelocity = 0
}

local collisions = {
    {
        x = 0,
        y = 300,
        w = love.graphics.getWidth(),
        h = love.graphics.getHeight() - 300
    },
    {
        x = 200,
        y = 230,
        w = 20,
        h = 20
    },
    {
        x = 250,
        y = 260,
        w = 50,
        h = 10,
        tag = "semisolid"
    }
}

function AABBbox(box1, box2)
    return box1.x < box2.x + box2.w and
           box1.x + box1.w > box2.x and
           box1.y < box2.y + box2.h and
           box1.y + box1.h > box2.y
end

function AABB(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x1 + w1 > x2 and
           y1 < y2 + h2 and
           y1 + h1 > y2
end

function love.load()
    Object = require("lib.class")
    Camera = require("camera")
    Player = require("player")
    mainCamera = Camera(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    player = Player()
    love.graphics.setBackgroundColor(0.5, 0.5, 1)
end

function love.update(dt)
    player:update(dt)

    for _, collision in ipairs(collisions) do
        player:checkCollision(collision)
    end

    mainCamera:setPosition(player.x - love.graphics.getWidth() / 2 + player.w / 2, player.y - love.graphics.getHeight() / 2 + player.h / 2)
end

function love.draw()
    mainCamera:set()

    love.graphics.setColor(0.3, 0.3, 0.3)
    for _, collision in ipairs(collisions) do
        if mainCamera:isOnScreen(collision) then
            love.graphics.rectangle("fill", collision.x, collision.y, collision.w, collision.h)
        end
    end

    player:draw()

    mainCamera:unset()
end