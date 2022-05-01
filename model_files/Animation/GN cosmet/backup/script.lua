rotation = nil
lastRotation = vectors.of({})
velocity = nil
distanceVelociy = 0
distanceTraveled = 0

hair = {
    backL = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.offset.MIMIC_HEAD.HAIR.longHair.LHL,
        restForce = 0.1,
        waveMult = 0.1,
        friction = 0.9,
    },
    backM= {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.offset.MIMIC_HEAD.HAIR.longHair.LHM,
        restForce = 0.1,
        waveMult = 0.1,
        friction = 0.9,
    },
    backR = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.offset.MIMIC_HEAD.HAIR.longHair.LHR,
        restForce = 0.1,
        waveMult = 0.1,
        friction = 0.9,
    },
    backBoffset = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.offset.MIMIC_HEAD.HAIR.longHair.HBoffset,
        restForce = 0.1,
        waveMult = 0.1,
        friction = 0.9,
    },
    backB = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.offset.MIMIC_HEAD.HAIR.longHair.HBoffset.HairBackBottom,
        restForce = 0.07,
        waveMult = 0.1,
        friction = 0.9,
    },
    frontL1 = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.offset.MIMIC_HEAD.HAIR.hairline1,
        restForce = 0.1,
        waveMult = vectors.of({0.2,1,-0.1}),
        friction = 0.9,
    },
    frontL2 = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.offset.MIMIC_HEAD.HAIR.hairline1.hairline2,
        restForce = 0.07,
        waveMult = vectors.of({0.2,1,-0.12}),
        friction = 0.9,
    },
    hairlineRight = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.offset.MIMIC_HEAD.HAIR.hairlineRight,
        restForce = 0.1,
        waveMult = vectors.of({0.11,1,-0.05}),
        friction = 0.6,
    },
    hairlineLeft = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.offset.MIMIC_HEAD.HAIR.hairlineLeft,
        restForce = 0.09,
        waveMult = vectors.of({0.1,1,-0.05}),
        friction = 0.6,
    },
    longHair = {
        physics = false,
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.offset.MIMIC_HEAD.HAIR.longHair,
    },
}
---==== ACCESSORIES ====---
acs = {
    ringMaster = "ringmaster"
}



function applyColor(table)
    model.offset.MIMIC_HEAD.H_accessory.H_glasses.setColor(table[3])
    model.offset.MIMIC_HEAD.H_accessory.H_ringmaster.setColor(table[1])
    model.offset.MIMIC_HEAD.HAIR.setColor(table[2])
    model.offset.B.B_JACKET.setColor(table[4])
    model.offset.B.AL.AL_JACKET.setColor(table[4])
    model.offset.B.AR.AR_JACKET.setColor(table[4])
    model.offset.B.B_SHIRT.setColor(table[5])
    model.offset.B.AL.AL_SHIRT.setColor(table[5])
    model.offset.B.AR.AR_SHIRT.setColor(table[5])
    model.offset.B.AL.ALL.ALL_SHIRT.setColor(table[5])
    model.offset.B.AR.ARL.ARL_SHIRT.setColor(table[5])
    model.offset.B.B_accessory.B_ringmaster.setColor(table[4])
    model.offset.LL.setColor(table[6])
    model.offset.LR.setColor(table[6])
    model.offset.B.AL.ALL.ALL_accessory.setColor(table[8])
    model.offset.B.AR.ARL.ARL_accessory.setColor(table[8])
    model.offset.B.AR.AR_accessory.setColor(table[8])
    model.offset.B.AL.AL_accessory.setColor(table[8])
    model.offset.B.AR.ARL.ARL_GLOVES.setColor(table[9])
    model.offset.B.AL.ALL.ALL_GLOVES.setColor(table[9])

end

function toggleAccessory(name,type,toggle)
    if type == "H" then
        model.offset.MIMIC_HEAD.H_accessory["H_"..name].setEnabled(toggle)
    end
    if type == "B" then
        model.offset.B.B_accessory["B_"..name].setEnabled(toggle)
    end
    if type == "LL" then
        model.offset.LL.LL_accessory["LL_"..name].setEnabled(toggle)
    end
    if type == "LR" then
        model.offset.LR.LR_accessory["LR_"..name].setEnabled(toggle)
    end
    if type == "LLK" then
        model.offset.LL.LLK_accessory["LLK_"..name].setEnabled(toggle)
    end
    if type == "LRK" then
        model.offset.LR.LRK_accessory["LRK_"..name].setEnabled(toggle)
    end
    if type == "AL" then
        model.offset.B.AL.AL_accessory["AL_"..name].setEnabled(toggle)
    end
    if type == "AR" then
        model.offset.B.AR.AR_accessory["AR_"..name].setEnabled(toggle)
    end
    if type == "ALL" then
        model.offset.B.AL.ALL.ALL_accessory["ALL_"..name].setEnabled(toggle)
    end
    if type == "ARL" then
        model.offset.B.AR.ARL.ARL_accessory["ARL_"..name].setEnabled(toggle)
    end
    if type == "EVERYTHING" then
        model.offset.MIMIC_HEAD.H_accessory["H_"..name].setEnabled(toggle)
        model.offset.B.B_accessory["B_"..name].setEnabled(toggle)
        model.offset.LL.LL_accessory["LL_"..name].setEnabled(toggle)
        model.offset.LR.LR_accessory["LR_"..name].setEnabled(toggle)
        model.offset.LL.LLK.LLK_accessory["LLK_"..name].setEnabled(toggle)
        model.offset.LR.LRK.LRK_accessory["LRK_"..name].setEnabled(toggle)
        model.offset.B.AL.AL_accessory["AL_"..name].setEnabled(toggle)
        model.offset.B.AR.AR_accessory["AR_"..name].setEnabled(toggle)
        model.offset.B.AL.ALL.ALL_accessory["ALL_"..name].setEnabled(toggle)
        model.offset.B.AR.ARL.ARL_accessory["ARL_"..name].setEnabled(toggle)
    end
end
--[[
1. HAT
2. HAIR
3. GLASSES
4. JACKET
5. SHIRT
6. PANTS
7. SHOES
8. RING/SHOULDERS
9.GLOVES
]]--
---=====================-=--
function player_init()
    applyColor({
            {1,1,1},--HAT
            {1,1,1},--HAIR
            {1,1,1},--GLASSES
            {1,1,1},--JACKET
            {1,1,1},--SHIRT
            {1,1,1},--PANTS
            {1,1,1},--SHOES
            {1,1,1},--RING/SHOULDERS
            {1,1,1},--GLOVES
        })
    lastRotation = player.getRot()
    rotation = player.getRot()

    for _, v in pairs(vanilla_model) do
        v.setEnabled(false)
    end
    for key, value in pairs(armor_model) do
        value.setEnabled(false)
    end
    toggleAccessory("ringmaster","EVERYTHING",true)
    for key, value in pairs(animation) do
        if type(value) == "table" then
            value.setBlendTime(0.1)
        end
    end
    animation.SquareDance.setSpeed(0.8)
    animation.walk_forward.setSpeed(0.6)

end

network.registerPing("interact")

action_wheel.SLOT_1.setItem("minecraft:barrier")
action_wheel.SLOT_1.setTitle("Idle")
action_wheel.SLOT_1.setFunction(function ()
    network.ping("interact","rest")
end)

action_wheel.SLOT_2.setItem("minecraft:grass_block")
action_wheel.SLOT_2.setTitle("Square Dance")
action_wheel.SLOT_2.setFunction(function ()
    network.ping("interact","SquareDance")
end)

action_wheel.SLOT_3.setItem("minecraft:oak_stairs")
action_wheel.SLOT_3.setTitle("Sit Down")
action_wheel.SLOT_3.setFunction(function ()
    network.ping("interact","sitDown")
end)

action_wheel.SLOT_3.setItem("minecraft:glowstone")
action_wheel.SLOT_3.setTitle("Carmalledansen")
action_wheel.SLOT_3.setFunction(function ()
    network.ping("interact","Carmalledansen")
end)


function interact(anim)
    animation.switchTo(anim,"INTERACTION")
end

lastMovementAnimation = nil
currentMovementAnimation = nil

lastInteractionAnimation = nil
currentInteractionAnimation = nil
function animation.switchTo(anim,type)
    if type == "MOVEMENT" then
        lastMovementAnimation = currentMovementAnimation
        if lastMovementAnimation ~= nil then
            if lastMovementAnimation ~= anim then
                animation[lastMovementAnimation].stop()
            end
        end
        animation[anim].start()
        currentMovementAnimation = anim
        return
    end
    if type == "INTERACTION" then
        lastInteractionAnimation = currentInteractionAnimation
        if lastInteractionAnimation ~= nil then
            if lastInteractionAnimation ~= anim then
                animation[lastInteractionAnimation].stop()
            end
        end
        animation[anim].play()
        currentInteractionAnimation = anim
        return
    end
end

function animation.getCurrent()
    return current
end

function animation.stopCurrent()
    if current ~= nil then
        animation[current].stop()
        current = nil
    end
end

function onDamage(dmg,source)
    log(source)
end

function tick()
    --log(animation.getCurrent())
    lastRotation = rotation
    rotation = player.getRot()
    velocity = player.getVelocity()

    distanceVelociy = (velocity*vectors.of({1,0,1})).distanceTo(vectors.of({}))
    distanceTraveled = distanceTraveled + distanceVelociy
    if player.isOnGround() then
        if distanceVelociy > 0.54 then
            if player.isSprinting() then
                animation.switchTo("sprint","MOVEMENT")
            else
                animation.switchTo("walk_forward","MOVEMENT")
            end
        else
            animation.switchTo("idle","MOVEMENT")
        end
    else
        animation.switchTo("jump","MOVEMENT")
    end

    local localVel = {
        x=(math.sin(math.rad(-player.getRot().y))*velocity.x)+(math.cos(math.rad(-player.getRot().y))*velocity.z),
        0,
        z=(math.sin(math.rad(-player.getRot().y+90))*velocity.x)+(math.cos(math.rad(-player.getRot().y+90))*velocity.z)
    }

    for name, h in pairs(hair) do
        h.lastRotation = h.rotation
        if h.physics then
            h.rotation = h.rotation + h.velocity
            h.velocity = h.velocity * h.friction - h.rotation * h.restForce
            h.velocity = h.velocity + vectors.of({localVel.x*-50 + (velocity.y-math.abs(velocity.y))*90,0,(rotation.y-lastRotation.y)}) * h.waveMult
        end
        
        if name == "longHair" then
            if rotation.x < 0 then
                h.rotation = vectors.of({rotation.x})
            else
                h.rotation = vectors.of({0})
            end
        end
        if name == "backB" then
            if rotation.x > 0 then
                h.rotation = vectors.of({rotation.x,h.rotation.y,h.rotation.z})
            else
                h.rotation = vectors.of({0})
                h.velocity = h.velocity * vectors.of({0,1,1})
            end
        end
    end
end

function world_render(delta)
    for name, h in pairs(hair) do
        h.model.setRot(vectors.lerp(h.lastRotation,h.rotation,delta))
    end
end
