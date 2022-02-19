--GNamimates is GN but amimates
--by: setamimaNG
currentMaterial = "minecraft:glass"

currentPlayerPos = nil
lastPlayerPos = nil
velocity = nil
lastDistVel = 0
distVel= 0
distTrav = 0
toggleBetweenSnapNwalk = 0

--attributs
hoppingSpeed = 1.5
hopHeight = 16

action_wheel.setRightSize(1)
action_wheel.SLOT_1.setFunction(function ()
    if player.getTargetedBlockPos(false) ~= nil then
        currentMaterial = world.getBlockState(player.getTargetedBlockPos(false)).name
    else
        log("you need to look at a block you want to turn into!")
    end
    
end)

interact = keybind.getRegisteredKeybind("key.use")


for _, v in pairs(vanilla_model) do
    v.setEnabled(false)
end


function player_init()
    currentPlayerPos = player.getPos()
    lastPlayerPos = currentPlayerPos
    velocity = vectors.of({0})
end

function tick()
    lastPlayerPos = currentPlayerPos
    currentPlayerPos = player.getPos()
    velocity = currentPlayerPos - lastPlayerPos
    lastDistVel = distVel

    if player.getTargetedBlockPos(false) ~= nil then
        action_wheel.SLOT_1.setTitle("switch to a "..world.getBlockState(player.getTargetedBlockPos(false)).name)
        action_wheel.SLOT_1.setItem("minecraft:spectral_arrow")
    else
        action_wheel.SLOT_1.setTitle("look into what you want to be...")
        action_wheel.SLOT_1.setItem("minecraft:barrier")
    end

    if player.isGrounded() then
        distVel =  velocity.distanceTo(vectors.of({0,velocity.y}))
        distTrav = distTrav + distVel
    else
        distVel = 0
    end
end

function render(delta)
    local actualPlayerPos = vectors.lerp(lastPlayerPos,currentPlayerPos,delta)
    local actualDistTrav = lerp(distTrav,distTrav+distVel,delta)
    local actualDistVel = lerp(lastDistVel,distVel,delta)
    local hop = math.abs(math.sin(actualDistTrav*hoppingSpeed)*(hopHeight/16))*math.min(actualDistVel)*-2

    model.NO_PARENT.setPos(actualPlayerPos*vectors.of({-16,-16,16}))
    model.NO_PARENT.setRot({0,math.deg(math.atan2(velocity.x,velocity.z))})
    model.NO_PARENT.offset.setRot({math.sin(actualDistTrav*hoppingSpeed*2)*math.min(actualDistVel,1)*30})

    if distVel < 0.05 and player.isGrounded() then
        
        if toggleBetweenSnapNwalk < 21 then
            toggleBetweenSnapNwalk = toggleBetweenSnapNwalk + 1
        else
            nameplate.ENTITY.setEnabled(false)
        end
        
    else
        nameplate.ENTITY.setEnabled(true)

        if toggleBetweenSnapNwalk > 0 then
            toggleBetweenSnapNwalk = toggleBetweenSnapNwalk - 4
        end
    end

    renderer.renderBlock(currentMaterial,model.NO_PARENT.offset,false,vectors.lerp(vectors.of({-8,-math.abs(math.sin(actualDistTrav*hoppingSpeed)*hopHeight)*math.min(actualDistVel)*2,8}),vectors.of({-actualPlayerPos.x%1,0,-actualPlayerPos.z%1})*vectors.of({-16,16,16}),math.min(math.max(toggleBetweenSnapNwalk*0.05,0),1)),vectors.of({0,math.deg(-math.atan2(velocity.x,velocity.z))}))
    
    nameplate.ENTITY.setPos({0,-1-hop})
    camera.FIRST_PERSON.setPos({0,-1-hop})
    camera.THIRD_PERSON.setPos({0,-.5-(hop*0.5)})
end

function lerp(a, b, x)
    return a + (b - a) * x
end

function onDamage(dmg)
    sound.playSound("minecraft:item.totem.use",player.getPos(),{1,1})
end