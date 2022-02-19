
currentPosition = nil
lastPosition = nil
linear_velocity = nil

currentRotation = nil
lastRotation = nil
angular_velocity = nil

lastBodyYaw = nil
currentBodyYaw = nil

function player_init()
    currentPosition = player.getPos()
    lastPosition = currentPosition
    linear_velocity = vectors.of({0})

    currentRotation = player.getRot()
    lastRotation = currentRotation

    currentBodyYaw = player.getBodyYaw()
    lastBodyYaw = currentBodyYaw
end

function tick()
    lastPosition = currentPosition
    currentPosition = player.getPos()
    linear_velocity = currentPosition - lastPosition

    lastRotation = currentRotation
    currentRotation = player.getRot()
    angular_velocity = currentRotation - lastRotation

    lastBodyYaw = currentBodyYaw
    currentBodyYaw = player.getBodyYaw()
end


function tick()
    if player.getVehicle() ~= nil and (player.getVehicle().getType() == "minecraft:boat" )then
        renderer.setMountEnabled(false)
        vehicleMode(false)
     else
         renderer.setMountEnabled(true)
         vehicleMode(true)
     end
end

model.NO_PARENT.offset.setPos({0,-8,0})

function vehicleMode(is)
    for key, value in pairs(model.NO_PARENT.offset) do
        if type(value) == "table" then
            value.setEnabled((not is))
        end
    end
    if is then
        for key, value in pairs(vanilla_model) do
            value.setPos(vectors.of({0,0,0}))
        end
        camera.FIRST_PERSON.setPos({0})
        camera.THIRD_PERSON.setPos({0})
    else
        for key, value in pairs(vanilla_model) do
            value.setPos(vectors.of({0,-16,8}))
        end
        camera.FIRST_PERSON.setPos({0,1})
        camera.THIRD_PERSON.setPos({0,0})
    end
end

function world_render(delta)
    model.NO_PARENT.setPos(vectors.lerp(lastPosition,currentPosition,delta)*vectors.of({-16,-16,16}))
    model.NO_PARENT.setRot({0,-lerp(lastBodyYaw,currentBodyYaw,delta)+180})
    model.NO_PARENT.offset.handle.setRot({0,(lastBodyYaw-currentBodyYaw)*4})
    model.NO_PARENT.setUV(vectors.of({lastBodyYaw-currentBodyYaw,0}))
end

function lerp(a, b, x)
    return a + (b - a) * x
end