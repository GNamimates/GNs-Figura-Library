--double barrel by GNamimates (u-u)
model.NO_PARENT.primaryHand.cube.setTexture("Skin")
model.NO_PARENT.secondaryHand.cube.setTexture("Skin")

animation.shoot.setSpeed(100)
animation.shoot.play()

vanilla_model.RIGHT_ARM.setEnabled(false)
vanilla_model.RIGHT_SLEEVE.setEnabled(false)

vanilla_model.LEFT_ARM.setEnabled(false)
vanilla_model.LEFT_SLEEVE.setEnabled(false)

currentPosition = nil
lastPosition = nil
velocity = nil

shoot = keybind.newKey("Shoot","MOUSE_BUTTON_1")
holdingShoot = false

currentRotation = nil
lastRotation = nil

shootCooldownTime = 10
cooldown = 0

maxAmmo = 9999999999999999

isWalking = false
ammo = maxAmmo
power = 10

keybind.newKey("Reload","R")

isHoldingNothing = false
wasHoldingNothing = false

lastWalkingBlendWeight = 0
walkingBlendWeight = 0

function player_init()
    currentPosition = player.getPos()
    lastPosition = currentPosition
    velocity = vectors.of({0})

    currentRotation = player.getRot()
    lastRotation = currentRotation
    animation.intro.play()
    animation.walk.play()
    animation.walk.setSpeed(2)
end

function tick()
    wasHoldingNothing = isHoldingNothing
    isHoldingNothing = (player.getEquipmentItem(1).getType() == "minecraft:air")
    cooldown = cooldown + 1

    if wasHoldingNothing ~= isHoldingNothing then
        if isHoldingNothing then
            model.NO_PARENT.setEnabled(true)
            vanilla_model.RIGHT_ARM.setEnabled(false)
            vanilla_model.RIGHT_SLEEVE.setEnabled(false)

            vanilla_model.LEFT_ARM.setEnabled(false)
            vanilla_model.LEFT_SLEEVE.setEnabled(false)
            animation.intro.play()
        else
            model.NO_PARENT.setEnabled(false)
            vanilla_model.RIGHT_ARM.setEnabled(true)
            vanilla_model.RIGHT_SLEEVE.setEnabled(true)

            vanilla_model.LEFT_ARM.setEnabled(true)
            vanilla_model.LEFT_SLEEVE.setEnabled(true)
        end
    end

    if isHoldingNothing then
            if shoot.isPressed() then
                if ammo > 0 then
                    if shootCooldownTime < cooldown then
                        walkingBlendWeight = 0
                        animation.shoot.setSpeed(1)
                        animation.shoot.play()
                        sound.playCustomSound("shoot",player.getPos(),{1,1})
                        chat.sendMessage("/summon arrow ~ ~1.5 ~ {Motion:["..antiInt(player.getLookDir().x*power)..","..antiInt(player.getLookDir().y*power)..","..antiInt(player.getLookDir().z*power).."],Owner:"..tostring(player.getUUID())..",Silent:1,life:1195}")
                        cooldown = 0
                    end
                end
            end
        if ammo <= 0 and cooldown > shootCooldownTime then
            if not animation.reload.isPlaying() then
                animation.reload.play()
                ammo = maxAmmo
                cooldown = 20
                sound.playCustomSound("reload",player.getPos(),{1,1})
            end
        end
    end

    if (velocity*vectors.of({1,0,1})).distanceTo(vectors.of({})) > 0.1 then
        isWalking = true
        if cooldown < shootCooldownTime then
            isWalking = false
        end
    else
        isWalking = false
    end
    lastWalkingBlendWeight = walkingBlendWeight
    if isWalking then
        walkingBlendWeight = lerp(walkingBlendWeight,1,0.5)
    else
        walkingBlendWeight = lerp(walkingBlendWeight,0,0.5)
    end
    

    lastPosition = currentPosition
    currentPosition = player.getPos()
    velocity = currentPosition - lastPosition

    lastRotation = currentRotation
    currentRotation = player.getRot()
end

function world_render(delta)
    animation.walk.setBlendWeight(lerp(lastWalkingBlendWeight,walkingBlendWeight,delta))
    camera.FIRST_PERSON.setRot(model.Hrot.getAnimRot())
    camera.THIRD_PERSON.setRot(model.Hrot.getAnimRot())
    model.NO_PARENT.setPos((vectors.lerp(lastPosition,currentPosition,delta)*vectors.of({-16,-16,16}))-vectors.of({0,player.getEyeHeight()*16}))
    model.NO_PARENT.setRot((vectors.lerp(lastRotation,currentRotation,delta)*vectors.of({-1,-1,-1})+vectors.of({0,180})))
end

function lerp(a, b, x)
    return a + (b - a) * x
end

function antiInt(value)
    local result = (math.floor((value+0.5)*360)/360)-0.5
    if result == math.floor(result+0.5) then
        return result+0.001
    else
        return result
    end
end