
currentPos = nil
lastPos = nil
linearVelocity = nil

currentRot = nil
lastRot = nil
angularVelocity = nil

function player_init()
    currentPos = player.getPos()
    lastPos = currentPos
    linearVelocity = vectors.of({0})

    currentRot = player.getRot()
    lastPos = currentRot
    angularVelocity = vectors.of({0})
end

function tick()
    lastPos = currentPos
    currentPos = player.getPos()
    linearVelocity = currentPos - lastPos

    lastRot = currentRot
    currentRot = player.getRot()
    angularVelocity = currentRot - lastPos
end

function world_render(delta)
    model.NO_PARENT.setPos(vectors.lerp(lastPos,currentPos,delta)*vectors.of({-16,-16,16}))
end

function lerp(a, b, x)
    return a + (b - a) * x
end
