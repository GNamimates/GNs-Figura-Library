--GNamimates is boom
position = vectors.of({})
lastPos = position
velocity = vectors.of({})

function player_init()
    position = player.getPos()+vectors.of({0,player.getEyeHeight()})
end

function tick()
    if player.getTargetedBlockPos(false) then
        velocity = velocity - (position-player.getTargetedBlockPos(false)).normalized()*0.05
    else
        velocity = velocity - ((player.getLookDir()*-10)+(position-player.getPos())).normalized()*0.05
    end
    velocity = velocity * 0.95
    lastPos = position
    position = position + velocity
    model.NO_PARENT.rocket1.setRot(lookat(lastPos,position))
    if world.getBlockState(position).name ~= "minecraft:air" then
        chat.sendMessage("/summon creeper "..position.x.." "..position.y.." "..position.z.." {Fuse:-1}")
    end
    for i = 1, 10, 1 do
        particle.addParticle("minecraft:smoke",{position.x,position.y,position.z,-velocity.x*0.1,-velocity.y*0.1,-velocity.z*0.1})
    end
end

function world_render(delta)
    model.NO_PARENT.rocket1.setPos(vectors.lerp(lastPos,position,delta)*vectors.of({-16,-16,16}))
end

function lookat(a,b)
    local offset = b-a
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end

