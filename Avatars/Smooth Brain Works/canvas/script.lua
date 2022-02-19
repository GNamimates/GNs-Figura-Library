
PI = 3.14159
PI2 = 3.14159*2

canvasPosition = vectors.of({})
canvasLastPosition = canvasPosition
canvasRot = 0

lastCursorPos = vectors.of({})
cursorPos = vectors.of({})

lastVelocity = vectors.of({})
velocity = vectors.of({})

isMovingCanvas = false

ping.toggleMovingCanvas = function (bool)isMovingCanvas = bool end

playerRot = vectors.of({})

--action wheel
action_wheel.SLOT_1.setTitle("Move/place Canvas")
action_wheel.SLOT_1.setFunction(function ()
    ping.toggleMovingCanvas(not isMovingCanvas)
end)


function tick()
    lastCursorPos = cursorPos
    cursorPos = vectors.of({((((player.getRot().y+canvasRot)*0.2)+PI2)*0.1),(player.getRot().x)*0.02+0.5})
    cursorPos = vectors.of({
        math.tan(math.rad(player.getRot().y))+0.5,
        math.tan(math.rad(player.getRot().x))+0.4-(player.getPos().y-canvasPosition.y)
    })
    --cursorPos = vectors.of({clamp(cursorPos.x,0,1),clamp(cursorPos.y,0,1)})

    lastVelocity = velocity
    velocity = lastCursorPos-cursorPos
    
    canvasLastPosition = canvasPosition
    if isMovingCanvas then
        canvasPosition = player.getPos()
        canvasRot = -player.getRot().y
    end
end


function world_render(delta)
    camera.FIRST_PERSON.setRot(player.getRot()*vectors.of({-1,-1,-1}))
    playerRot = player.getRot()
    model.NO_PARENT.setPos(vectors.lerp(canvasLastPosition,canvasPosition,delta)*vectors.of({-16,-16,16}))
    if isMovingCanvas then
        model.NO_PARENT.setRot({0,canvasRot})
    end
    model.NO_PARENT.cursor.setPos(vectors.lerp(lastCursorPos,cursorPos,delta)*16)
    model.NO_PARENT.cursor.setRot({lerp(lastVelocity.y,velocity.y,delta)*90,lerp(-lastVelocity.x,-velocity.x,delta)*90,0})
end

function lerp(a, b, x)
    return a + (b - a) * x
end


function clamp(value,low,high)
    return math.min(math.max(value, low), high)
end
