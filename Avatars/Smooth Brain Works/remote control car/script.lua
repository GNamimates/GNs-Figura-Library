---@diagnostic disable: undefined-global,undefined-field
--=====CONFIG==========================
--NOTE THIS ONLY WORKS FOR FIGURA 0.0.7+
CarCamMode = false -- if the player camera should be inside the vehicle
FollowPlayer = false -- follow player
friction = 0.8 --the higher the slipper-ier (higher than one makes the car go speed)
max_speed = 60 --in km/h
wheelRotationModifier = 0.5 -- this value gets multiplied to the wheels rotation

--paths
-- change steeringWHeel to nil if you dont want a steering wheel >:P 
steeringWHeel = model.NO_PARENT_car.offset.steeringWheel.joint
offset = model.NO_PARENT_car.offset
wheels = {
    front = {--front wheels
        model.NO_PARENT_car.FL,
        model.NO_PARENT_car.FR,

    },
    back = {--back wheels
        model.NO_PARENT_car.BL,
        model.NO_PARENT_car.BR,
    }
}

--============CREDITS=================
--
--thanks to superpowers04 for some stuff XD
--thanks to _Rayop_ for the car structure
--and the wonderful internet for helping me GNamimates code this easier than I expected :)
--gn sucks
--=======================================

position = vectors.of({0,1,0})
rotation = 0
linear_velocity = vectors.of({0,0,0})

serverPos = position
serverRot = rotation

--STATS N STUFF

positionUpdateTimer = 0

localLinearVelocity = {x=0,y=0,z=0}
distanceDriven = 0
airTime = 0
lowOffset = 0.0
tilt = 0 --front n back | used so when climbing blocks the car would look up1

angular_velocity = 10 -- only Y
steer = 0
--sounds
engineSoundTimer = 0

--== keybinds ==--
throttle = keybind.newKey("Throttle","U")
reverse = keybind.newKey("Reverse","J")
steerRight = keybind.newKey("Steer Right","K")
steerLeft = keybind.newKey("Steer Left","H")
reset = keybind.newKey("Reset","N")

STEER = 10
SPEED = 0

lastPos = position
--ACTION WHEEL
action_wheel.setRightSize(2)
--car camera mode
action_wheel.SLOT_1.setTexture("Custom")
action_wheel.SLOT_1.setUV({0,220},{4,4},{32,32})
action_wheel.SLOT_1.setTitle("Toggle Vehicle Camera")
action_wheel.SLOT_1.setFunction(function ()
    CarCamMode = not CarCamMode
    model.HEAD_vr_headset.setEnabled(CarCamMode)
end)
--follow player
action_wheel.SLOT_2.setTexture("Custom")
action_wheel.SLOT_2.setUV({4,220},{4,4},{32,32})
action_wheel.SLOT_2.setTitle("Auto Follow Player Toggle")
action_wheel.SLOT_2.setFunction(function ()
    FollowPlayer = not FollowPlayer
    log("Follow Player: "..tostring(FollowPlayer))
end)

function player_init()
    model.HEAD_vr_headset.setEnabled(CarCamMode)
    --== making stuff work on multiplayer ==-
    ping.posUpdate = function(arg) serverPos = arg.p serverRot = arg.r end
    position = vectors.of({math.floor(player.getPos().x)+0.5,math.floor(player.getPos().y),math.floor(player.getPos().z)+0.5})
    serverPos = position
end

function tick()
    engineSoundTimer = engineSoundTimer - 1
    if not client.isPaused() then
        if client.isWindowFocused() then
            if math.abs(localLinearVelocity.z) > -0.1 then
                if engineSoundTimer <= 0 then
                    sound.playSound("block.piston.contract",serverPos,{math.abs(localLinearVelocity.z)*0.5+0.1,math.abs(localLinearVelocity.z*0.7+0.5)})
                    engineSoundTimer = 1.05/((math.abs(localLinearVelocity.z)*0.7)+0.5)
                end
            end
        end
    end

    if client.isHost() then
        --server position update
        positionUpdateTimer = positionUpdateTimer + 1
        if positionUpdateTimer > 5 then
            ping.posUpdate({p=position,r=rotation})
            positionUpdateTimer = 0
        end
        --teleports the car to the player
        if reset.wasPressed() then
            position = vectors.of({math.floor(player.getPos().x)+0.5,math.floor(player.getPos().y),math.floor(player.getPos().z)+0.5})
            rotation = -player.getRot().y+180
            linear_velocity = vectors.of({0,0,0})
        end
        --==PHYSICS
        position = position + linear_velocity
        rotation = rotation + angular_velocity
        --getting velocity locally to car rotation
        localLinearVelocity.z = (
            math.sin(math.rad(-rotation))*linear_velocity.x)-
            (math.cos(math.rad(-rotation))*linear_velocity.z)
        localLinearVelocity.x = (
            math.sin(math.rad(rotation))*linear_velocity.z)-
            (math.cos(math.rad(rotation))*linear_velocity.x)

        linear_velocity.x = linear_velocity.x * friction
        linear_velocity.z = linear_velocity.z * friction
        distanceDriven = distanceDriven + localLinearVelocity.z*360

        if math.abs(angular_velocity) > 0.01 then
            angular_velocity = angular_velocity * friction
        else
            angular_velocity = 0
        end

        --==CONTROLS
        --THROTTLE
        local isMoving = false
        if throttle.isPressed() then 
            linear_velocity = linear_velocity + vectors.of({math.sin(math.rad(serverRot))*-SPEED,0,math.cos(math.rad(serverRot))*-SPEED})
            isMoving = true
        end
        if reverse.isPressed() then
            linear_velocity = linear_velocity + vectors.of({math.sin(math.rad(serverRot))*SPEED,0,math.cos(math.rad(serverRot))*SPEED})
            isMoving = true
        end
        --follow player | auto pilot
        if position.distanceTo(player.getPos()) > 1 and FollowPlayer then
            isMoving = false
            rotation = math.atan2(position.x-player.getPos().x,position.z-player.getPos().z)*180/3.14159
            linear_velocity = linear_velocity + vectors.of({math.sin(math.rad(serverRot))*-SPEED,0,math.cos(math.rad(serverRot))*-SPEED})
        end

        if isMoving then
            SPEED = lerp(SPEED,max_speed/60/20,0.05)
        else
            SPEED = SPEED *0.5
        end
        steer = 0
        --STERRING
        if steerRight.isPressed() then
            steer = -STEER
        end
        if steerLeft.isPressed() then
            steer = STEER
        end
        
        

        angular_velocity = angular_velocity + (steer*localLinearVelocity.z)
        --check if inside the ground
        --check if standing on solid ground
        --check if standing on slabs
        --Y adjustment
        local floorPos = position
        local coll = collision(floorPos)

        position.y = position.y + linear_velocity.y
        if coll.isColliding then
            linear_velocity.y = 0.0001
            position = coll.position
        else
            linear_velocity.y = linear_velocity.y-0.02
        end
    else
        linear_velocity = lastPos-position
        localLinearVelocity.z = (
            math.sin(math.rad(-rotation))*linear_velocity.x)-
            (math.cos(math.rad(-rotation))*linear_velocity.z)
        localLinearVelocity.x = (
            math.sin(math.rad(rotation))*linear_velocity.z)-
            (math.cos(math.rad(rotation))*linear_velocity.x)
        
        lastPos = position
    end
end

function getMaxHeight(pointPos)
    local final = pointPos
        aabbs = world.getBlockState(pointPos).getCollisionShape()
        for index, value in ipairs(aabbs) do
            if value.x < final[1]-math.floor(final[1]) and value.w > final[1]-math.floor(final[1]) then
                if value.z < final[3]-math.floor(final[3]) and value.h > final[3]-math.floor(final[3]) then
                    final[2] = math.floor(final[2])+value.t--adjusts the position to the height of the ceilinEIGHEAGNEKADEVNI~$%!#@!%^$#()
                end
            end
        end
    return final
end

function world_render(delta)
    --Display
    if steeringWHeel ~= nil then
        steeringWHeel.setRot({0,0,lerp(steeringWHeel.getRot().z,steer*7,0.2)})
    end
    if client.isHost() then
        offset.setPos({0,lerp(lowOffset,offset.getPos().y,delta),0})
        offset.setRot({localLinearVelocity.z*20,0,localLinearVelocity.x*50})
        model.NO_PARENT_car.setPos({lerp(model.NO_PARENT_car.getPos().x,position.x*-16,delta),lerp(model.NO_PARENT_car.getPos().y,position.y*-16,delta),lerp(model.NO_PARENT_car.getPos().z,position.z*16,delta)})
        model.NO_PARENT_car.setRot({0,lerp_angle_deg(model.NO_PARENT_car.getRot().y,rotation,delta),0})
    else
        offset.setPos({0,lerp(lowOffset,offset.getPos().y,delta),0})
        offset.setRot({localLinearVelocity.z*20,0,localLinearVelocity.x*50})
        model.NO_PARENT_car.setPos({lerp(model.NO_PARENT_car.getPos().x,serverPos.x*-16,delta),lerp(model.NO_PARENT_car.getPos().y,serverPos.y*-16,delta),lerp(model.NO_PARENT_car.getPos().z,serverPos.z*16,delta)})
        model.NO_PARENT_car.setRot({0,lerp_angle_deg(model.NO_PARENT_car.getRot().y,serverRot,delta),0})
    end
    
    --wheels
    for index, value in ipairs(wheels.back) do
        if math.abs(localLinearVelocity.x) > 0.15 then
            --drifting particles
            particle.addParticle("minecraft:block",vectors.of({
            (model.NO_PARENT_car.getPos().x/-16)+(math.cos(math.rad(-rotation))*(value.getPivot().x/16))+(math.sin(math.rad(rotation))*(value.getPivot().z/-16)),
            model.NO_PARENT_car.getPos().y/-16,
            (model.NO_PARENT_car.getPos().z/16)+(math.sin(math.rad(-rotation))*(value.getPivot().x/16))+(math.cos(math.rad(rotation))*(value.getPivot().z/-16)),
            math.sin(math.rad(serverRot)),0,math.cos(math.rad(rotation))}),world.getBlockState(serverPos+vectors.of({0,-0.01,0})).name)
        end
        value.setRot({lerp(-distanceDriven*wheelRotationModifier,value.getRot().x,delta),0,0})
    end
    --front wheels-
    for index, value in ipairs(wheels.front) do
        value.setRot({lerp(-distanceDriven*wheelRotationModifier,value.getRot().x,delta),lerp(value.getRot().y,steer*3,0.2),0})
    end

    if CarCamMode then
        camera.FIRST_PERSON.setRot(model.NO_PARENT_car.getRot()*vectors.of({-1,-1,-1}))
        cameraSetWorldPos({
            (model.NO_PARENT_car.getPos()+model.NO_PARENT_car.offset.getPos())/vectors.of({-16,-16,16})+
            (linear_velocity*vectors.of({0.6,0,0.6}))+
            (vectors.of({
                math.cos(math.rad(model.NO_PARENT_car.getRot().y*-1))*-0.15,
                0.8,
                math.sin(math.rad(model.NO_PARENT_car.getRot().y*-1))*-0.15
            }))
        })
        
    else
        camera.FIRST_PERSON.setRot({0,0,0})
        camera.FIRST_PERSON.setPos({0,0,0})
    end
end


function ping.posUpdate(arg)
    serverPos = arg.p
    serverRot = arg.r
end


function lerp(a, b, x)
    return a + (b - a) * x
end


function lerp_angle_deg(a, b, x)
    x= 0.1
    if  math.abs(a + (b - a) * x) > math.abs(a + ((b+180) - a)) * x then
        return a + (b - a) * x
    else
        return (a + ((b+180) - a) * x)
    end
    
end

function lerp_angle_rad(a, b, x)
    x= 0.1
    if  math.abs(a + (b - a) * x) > math.abs(a + ((b-math.rad(360)) - a)) * x then
        return a + (b - a) * x
    else
        return (a + ((b-math.rad(360)) - a) * x)
    end
    
end


function tableDistance(table)
    local result = 0.0
    for I, _ in pairs(table) do
        result = result + math.pow(table[I],2)
    end
    return math.sqrt(result)
end

function dotp(value)
    return value/math.abs(value)
end

--cameraSetWorldPos by dragekk
--it isnt going to work if you set camera rotation after running this function
function cameraSetWorldPos(cam)
    if type(cam) == "table" then
        cam = vectors.of(cam)
    end
    local pos = cam-player.getPos()-vectors.of({0, player.getEyeHeight()})
    local cam_rot = camera.FIRST_PERSON.getRot()
    if not cam_rot then
        cam_rot = vectors.of({0, 0, 0})
    end
    local rot = player.getRot()+cam_rot
    local x = math.cos(math.rad(rot.y-90))*-pos.z+math.sin(math.rad(rot.y-90))*pos.x
    local z = math.cos(math.rad(rot.y))*-pos.z+math.sin(math.rad(rot.y))*pos.x
    local z = 1/math.cos(math.rad(rot.x))*z
    camera.FIRST_PERSON.setPos({
        math.min(math.max(x, -256), 256),
        math.min(math.max(pos.y-math.sin(math.rad(rot.x))*z, -256), 256),
        math.min(math.max(z, -256), 256)
    })
end

function collision(position)-- sorry idk what to name this lmao
    local point = vectors.of({position.x,position.y,position.z})
    local collision = world.getBlockState(point).getCollisionShape()
    local blockPos = vectors.of({point.x-math.floor(point.x),point.y-math.floor(point.y),point.z-math.floor(point.z)})
    local isColliding = false
    local normal = vectors.of({1,1,1})

    for index, value in ipairs(collision) do--loop through all the collision boxes
        if value.x < blockPos.x and value.w > blockPos.x then-- checks if inside the collision box
            if value.y < blockPos.y and value.t > blockPos.y then
                if value.z < blockPos.z and value.h > blockPos.z then
                    isColliding = true
                    point.y = math.floor(point.y)+value.t
                end
            end
        end
    end
    return {position=point,isColliding=isColliding}
end

pos = nil
_pos = nil
player_velocity = nil

function player_init()
    pos = player.getPos()
    _pos = pos
    player_velocity = vectors.of({0})
end

function tick()
    _pos = pos
    pos = player.getPos()
    player_velocity = pos - _pos
end
