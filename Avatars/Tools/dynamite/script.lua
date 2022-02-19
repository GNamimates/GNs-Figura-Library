position = {}
velocity = {}
isUsed = {}

maxCount = 10

function player_init()
    for i = 1, 1, 1 do
        table.insert(position,vectors.of({}))
        table.insert(velocity,vectors.of({}))
        table.insert(isUsed,false)
    end
end

index = 1 

throw = keybind.getRegisteredKeybind("key.attack")
isThrowing = false

function tick()
    if throw.isPressed() ~= isThrowing then
        if throw.isPressed() then
            position[index] = player.getPos()+vectors.of({0,player.getEyeHeight()})
            velocity[index] = player.getLookDir()
            isUsed[index] = true
            index = ((index)%maxCount)+1
        end
    end
    for i = 1, maxCount, 1 do
        if isUsed[i] then
            model.NO_PARENT["dynamite"..tostring(i)].setEnabled(true)
            position[i] = position[i] + velocity[i]
            velocity[i] = velocity[i] + vectors.of({0,-0.1,0})
            if world.getBlockState(position[i]).isCollidable() then
                isUsed[i] = false
                chat.sendMessage("/summon minecraft:creeper "..position[i].x.." "..position[i].y.." "..position[i].z.." {NoAI:1b,CanPickUpLoot:0b,Silent:1,Invulnerable:1,ExplosionRadius:2,Fuse:0,ignited:1}")
            end
        else
            model.NO_PARENT["dynamite"..tostring(i)].setEnabled(false)
        end
    end
    isThrowing = throw.isPressed()
end

function world_render(delta)
    for i = 1, maxCount, 1 do
        if isUsed[i] then
            model.NO_PARENT["dynamite"..tostring(i)].setPos(vectors.lerp(position[i]-velocity[i],position[i],delta)*vectors.of({-16,-16,16}))
            model.NO_PARENT["dynamite"..tostring(i)].setRot(lookat(position[i],position[i]+velocity[i]))
        end
    end
end


function lookat(a,b)
    local offset = b-a
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end