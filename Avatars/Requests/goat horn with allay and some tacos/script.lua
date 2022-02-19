playerCurrentPos = nil
playerLastPos = nil
velocity = nil

ROTATION_SPEED = 2

PI = 3.14159
aThirdOfPI = (PI*2/3)

function player_init()
    playerCurrentPos = player.getPos()
    playerLastPos = playerCurrentPos
    velocity = vectors.of({0})

    lantern1pos = playerCurrentPos
    lantern2pos = playerCurrentPos
    lantern3pos = playerCurrentPos
end

lantern1pos = vectors.of({0,0,0})
lantern1vel = vectors.of({0,0,0})

lantern2pos = vectors.of({0,0,0})
lantern2vel = vectors.of({0,0,0})

lantern3pos = vectors.of({0,0,0})
lantern3vel = vectors.of({0,0,0})

allayPos = vectors.of({0,0,0})
allayVel = vectors.of({0,0,0})

time = 0

function tick()
    time = time + 0.05*ROTATION_SPEED
    playerLastPos = playerCurrentPos
    playerCurrentPos = player.getPos()
    velocity = playerCurrentPos - playerLastPos

    lantern1vel = lantern1vel + ((playerCurrentPos+vectors.of({math.sin(time),0.5,math.cos(time)})-lantern1pos)*0.021)+(velocity/25)
    lantern2vel = lantern2vel + ((playerCurrentPos+vectors.of({math.sin(time+aThirdOfPI),0.5,math.cos(time+aThirdOfPI)})-lantern2pos)*0.025)+(velocity/25)
    lantern3vel = lantern3vel + ((playerCurrentPos+vectors.of({math.sin(time+aThirdOfPI+aThirdOfPI),0.5,math.cos(time+aThirdOfPI+aThirdOfPI)})-lantern3pos)*0.03)+(velocity/25)
    allayVel = allayVel + ((playerCurrentPos+vectors.of({math.cos(math.rad(player.getRot().y)),0.5,math.sin(math.rad(player.getRot().y))})-allayPos)*0.021)+(velocity/25)

    lantern1vel = lantern1vel *0.95
    lantern2vel = lantern2vel *0.95
    lantern3vel = lantern3vel *0.95
    allayVel = allayVel *0.95
    
    lantern1pos = lantern1pos + lantern1vel
    lantern2pos = lantern2pos + lantern2vel
    lantern3pos = lantern3pos + lantern3vel
    allayPos = allayPos + allayVel

    model.NO_PARENT.Taco1.setPos(lantern1pos*vectors.of({-16,-16,16}))
    model.NO_PARENT.Taco2.setPos(lantern2pos*vectors.of({-16,-16,16}))
    model.NO_PARENT.Taco3.setPos(lantern3pos*vectors.of({-16,-16,16}))
    model.NO_PARENT.allay.setPos(allayPos*vectors.of({-16,-16,16}))
    model.NO_PARENT.Taco1.setRot(vectors.of({
        -lantern1vel.z,
        time,
        -lantern1vel.x
    })*vectors.of({-16,-16,16}))
    model.NO_PARENT.Taco2.setRot(vectors.of({
        -lantern2vel.z,
        time,
        -lantern2vel.x
    })*vectors.of({-16,-16,16}))
    model.NO_PARENT.Taco3.setRot(vectors.of({
        -lantern3vel.z,
        time,
        -lantern3vel.x
    })*vectors.of({-16,-16,16}))
    if allayVel.distanceTo(vectors.of({})) > 0.1 then
        model.NO_PARENT.allay.setRot(vectors.of({
            0,
            math.deg(-math.atan2(allayVel.z,allayVel.x))-90,
            0
        }))
    end

    if lantern1pos.distanceTo(playerCurrentPos) > 25 then
        lantern1pos = playerCurrentPos+vectors.of({0,-3})
        lantern1vel = vectors.of({})
    end
    if lantern2pos.distanceTo(playerCurrentPos) > 25 then
        lantern2pos = playerCurrentPos+vectors.of({0,-3})
        lantern2vel = vectors.of({})
    end
    if lantern3pos.distanceTo(playerCurrentPos) > 25 then
        lantern3pos = playerCurrentPos+vectors.of({0,-3})
        lantern3vel = vectors.of({})
    end
    if allayPos.distanceTo(playerCurrentPos) > 25 then
        allayPos = playerCurrentPos+vectors.of({0,-3})
        allayVel = vectors.of({})
    end
    
end

function render(delta)
    model.NO_PARENT.Taco1.setPos(vectors.of({
        lerp(lantern1pos.x,lantern1pos.x+lantern1vel.x,delta),
        lerp(lantern1pos.y,lantern1pos.y+lantern1vel.y,delta),
        lerp(lantern1pos.z,lantern1pos.z+lantern1vel.z,delta)
    })*vectors.of({-16,-16,16}))
    model.NO_PARENT.Taco2.setPos(vectors.of({
        lerp(lantern2pos.x,lantern2pos.x+lantern2vel.x,delta),
        lerp(lantern2pos.y,lantern2pos.y+lantern2vel.y,delta),
        lerp(lantern2pos.z,lantern2pos.z+lantern2vel.z,delta)
    })*vectors.of({-16,-16,16}))
    model.NO_PARENT.Taco3.setPos(vectors.of({
        lerp(lantern3pos.x,lantern3pos.x+lantern3vel.x,delta),
        lerp(lantern3pos.y,lantern3pos.y+lantern3vel.y,delta),
        lerp(lantern3pos.z,lantern3pos.z+lantern3vel.z,delta)
    })*vectors.of({-16,-16,16}))
    model.NO_PARENT.allay.setPos(vectors.of({
        lerp(allayPos.x,allayPos.x+allayVel.x,delta),
        lerp(allayPos.y,allayPos.y+allayVel.y,delta),
        lerp(allayPos.z,allayPos.z+allayVel.z,delta)
    })*vectors.of({-16,-16,16}))
    
    model.NO_PARENT.Taco1.setRot(vectors.of({
        -lantern1vel.z,
        time,
        -lantern1vel.x
    })*vectors.of({-16,-16,16}))
    model.NO_PARENT.Taco2.setRot(vectors.of({
        -lantern2vel.z,
        time,
        -lantern2vel.x
    })*vectors.of({-16,-16,16}))
    model.NO_PARENT.Taco3.setRot(vectors.of({
        -lantern3vel.z,
        time,
        -lantern3vel.x
    })*vectors.of({-16,-16,16}))
    if allayVel.distanceTo(vectors.of({})) > 0.1 then
        model.NO_PARENT.allay.setRot(vectors.of({
            0,
            math.deg(-math.atan2(allayVel.z,allayVel.x))-90,
            0
        }))
    end
    model.NO_PARENT.allay.left_wing.setRot({math.sin(time*2)*45,0,math.cos(time*2)*30})
    model.NO_PARENT.allay.right_wing.setRot({math.sin(time*2)*45,0,math.cos(time*2)*-30})
end

function lerp(a, b, x)
    return a + (b - a) * x
end
--GN sucks