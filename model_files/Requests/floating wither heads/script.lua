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

time = 0

function tick()
    time = time + 0.05*ROTATION_SPEED
    playerLastPos = playerCurrentPos
    playerCurrentPos = player.getPos()
    velocity = playerCurrentPos - playerLastPos

    lantern1vel = lantern1vel + ((playerCurrentPos+vectors.of({math.sin(time),1+math.sin(time*2)*0.1,math.cos(time)})-lantern1pos)*0.021)+(velocity/25)
    lantern2vel = lantern2vel + ((playerCurrentPos+vectors.of({math.sin(time+aThirdOfPI),1+math.sin(time*2+1)*0.1,math.cos(time+aThirdOfPI)})-lantern2pos)*0.025)+(velocity/25)
    lantern3vel = lantern3vel + ((playerCurrentPos+vectors.of({math.sin(time+aThirdOfPI+aThirdOfPI),1+math.sin(time*2+2.1)*0.1,math.cos(time+aThirdOfPI+aThirdOfPI)})-lantern3pos)*0.03)+(velocity/25)

    lantern1vel = lantern1vel *0.95
    lantern2vel = lantern2vel *0.95
    lantern3vel = lantern3vel *0.95
    
    lastlantern1pos = lantern1pos
    lastlantern2pos = lantern2pos
    lastlantern3pos = lantern3pos

    lantern1pos = lantern1pos + lantern1vel
    lantern2pos = lantern2pos + lantern2vel
    lantern3pos = lantern3pos + lantern3vel

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
    if client.isHost() then
        model.NO_PARENT.setEnabled( not renderer.isFirstPerson())
    end
    if not renderer.isFirstPerson() then
        particle.addParticle("minecraft:smoke",lantern1pos)
        particle.addParticle("minecraft:smoke",lantern2pos)
        particle.addParticle("minecraft:smoke",lantern3pos)
    end
    
end

function world_render(delta)
    model.NO_PARENT.skull1.setPos(vectors.lerp(lastlantern1pos,lantern1pos,delta)*vectors.of({-16,-16,16}))
    model.NO_PARENT.skull2.setPos(vectors.lerp(lastlantern2pos,lantern2pos,delta)*vectors.of({-16,-16,16}))
    model.NO_PARENT.skull3.setPos(vectors.lerp(lastlantern3pos,lantern3pos,delta)*vectors.of({-16,-16,16}))
    model.NO_PARENT.skull1.setRot(lookat(vectors.lerp(lastlantern1pos,lantern1pos,delta),vectors.lerp(lastlantern1pos,lantern1pos,delta)+lantern1vel))
    model.NO_PARENT.skull2.setRot(lookat(vectors.lerp(lastlantern2pos,lantern2pos,delta),vectors.lerp(lastlantern2pos,lantern2pos,delta)+lantern2vel))
    model.NO_PARENT.skull3.setRot(lookat(vectors.lerp(lastlantern3pos,lantern3pos,delta),vectors.lerp(lastlantern3pos,lantern3pos,delta)+lantern3vel))
end

function lerp(a, b, x)
    return a + (b - a) * x
end


function lookat(a,b)
    local offset = b-a
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end

--GN sucks