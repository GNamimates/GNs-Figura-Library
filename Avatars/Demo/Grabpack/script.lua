

keyLeft = keybind.getRegisteredKeybind("key.attack")
keyRight = keybind.getRegisteredKeybind("key.use")

left = nil
right = nil

leftTransitionTime = 0
rightTransitionTime = 0

network.registerPing("rightArm")
network.registerPing("leftArm")

leftHandPos = vectors.of({})
rightHandPos = vectors.of({})

----------------------
currentPosition = nil
LastPosition = nil
linearVelocity = nil

currentRotation = nil
lastRotation = nil
angularVelocity = nil

function player_init()
    currentPosition = player.getPos()
    LastPosition = currentPosition
    linearVelocity = vectors.of({0})

    currentRotation = player.getRot()
    lastRotation = currentRotation
    angularVelocity = vectors.of({0})
    
    vanilla_model.RIGHT_ARM.setEnabled(false)
    vanilla_model.RIGHT_SLEEVE.setEnabled(false)
    vanilla_model.LEFT_ARM.setEnabled(false)
    vanilla_model.LEFT_SLEEVE.setEnabled(false)
end
--velocity calculator
function tick()
    LastPosition = currentPosition
    currentPosition = player.getPos()
    linearVelocity = currentPosition - LastPosition

    lastRotation = currentRotation
    currentRotation = player.getRot()
    angularVelocity = currentRotation - lastRotation

    if keyRight.isPressed() then
        if right ~= keyRight.isPressed() then
            if keyRight.isPressed() then
                network.ping("rightArm")
            end
        end
    end
    right = keyRight.isPressed()

    if keyLeft.isPressed() then
        if left ~= keyLeft.isPressed() then
            if keyLeft.isPressed() then
                network.ping("leftArm")
            end
        end
    end
    left = keyLeft.isPressed()

    if left then
        leftTransitionTime = math.min(leftTransitionTime + 0.1,1)
    else
        leftTransitionTime = math.max(leftTransitionTime - 0.1,0)
    end

    if right then
        rightTransitionTime = math.min(rightTransitionTime + 0.1,1)
    else
        rightTransitionTime = math.max(rightTransitionTime - 0.1,0)
    end
end

function world_render(delta)
    local truePos = vectors.of({
        lerp(LastPosition.x,currentPosition.x,delta),
        lerp(LastPosition.y,currentPosition.y,delta),
        lerp(LastPosition.z,currentPosition.z,delta),
    })
    model.NO_PARENT.setPos((truePos+vectors.of({0,player.getEyeHeight()}))*vectors.of({-16,-16,16}))
    local trueRot = vectors.of({
        lerp(lastRotation.x,currentRotation.x,delta),
        lerp(lastRotation.y,currentRotation.y,delta),
        lerp(lastRotation.z,currentRotation.z,delta),
    })
    model.NO_PARENT.setRot(trueRot*vectors.of({0,-1,0})+vectors.of({0,180,0}))

    local offsetL = localRot(trueRot.y,vectors.of({0.4,0.9}))+vectors.of({0,-0.258,0})
    local offsetR = localRot(trueRot.y,vectors.of({-0.4,0.9}))+vectors.of({0,-0.258,0})

    model.NO_PARENT_leftPole.setPos((leftHandPos+vectors.of({0.5,0.5,0.5}))*vectors.of({-16,-16,16})+vectors.of({0.5,0.5,0.5}))
    model.NO_PARENT_leftPole.setScale(vectors.of({1,(truePos+offsetL).distanceTo(leftHandPos+vectors.of({0.5,0.5,0.5}))+0.1,1})*vectors.of({1,8,1}))
    model.NO_PARENT_leftPole.setRot(lookat(leftHandPos+vectors.of({0.5,0.5,0.5}),truePos+offsetL))

    model.NO_PARENT_rightPole.setPos((rightHandPos+vectors.of({0.5,0.5,0.5}))*vectors.of({-16,-16,16})+vectors.of({0.5,0.5,0.5}))
    model.NO_PARENT_rightPole.setScale(vectors.of({1,(truePos+offsetR).distanceTo(rightHandPos+vectors.of({0.5,0.5,0.5}))+0.1,1})*vectors.of({1,8,1}))
    model.NO_PARENT_rightPole.setRot(lookat(rightHandPos+vectors.of({0.5,0.5,0.5}),truePos+offsetR))
end

function lerp(a, b, x)
    return a + (b - a) * x
end

function leftArm()
    if player.getTargetedBlockPos(false) ~= nil then
        leftHandPos = player.getTargetedBlockPos(false)
    end
end

function rightArm()
    if player.getTargetedBlockPos(false) ~= nil then
        rightHandPos = player.getTargetedBlockPos(false)
    end
end

function lookat(a,b)
    local offset = b-a
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end

function localRot(rot,coords)
    return vectors.of({math.sin(math.rad(-rot))*coords.y,player.getEyeHeight(),math.cos(math.rad(-rot))*coords.y})+vectors.of({math.cos(math.rad(-rot))*coords.x,0,math.sin(math.rad(rot))*coords.x})
end