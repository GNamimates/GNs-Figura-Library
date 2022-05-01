--==========GNamimates's AGENT 2.0==========--
--agent path in model
AGENT_PATH = model.NO_PARENT_AGENT
AGENT_BODY = model.NO_PARENT_AGENT.BODY -- this will be rotated towards movement
AGENT_HEAD = model.NO_PARENT_AGENT.H
--==========ATTRIBUTES=============--
WALK_SPEED = 0.11  --M/T aka Meters per Tick
FRICTION = 0.7 -- gets multiplied wih velocity X and Z
GRAVITY = -0.1 --only Y axis to for optimization purposes :P
JUMP_HEIGHT = 0.6
EYE_HEIGHT = 1.62

BHOP = true --bunny hopping

DISTANCE_BEFORE_TELEPORT_TO_OWNER = 20 --In blocks
DISTANCE_FOLLOW_OWNER = 3
DISTANCE_BEFORE_STOP_POSE_MOVEMENT = 32 -- stop posing the agent when the distance is greater than:

AVATAR_SCALE = 0.934
ALWAYS_HAVE_FRICTION = true

TARGET_POSITION_OFFSET = vectors.of({})
MAX_TIME_WANDER = 120
MIN_TIME_WANDER = 5

MAX_DISTANCE_WANDER = DISTANCE_FOLLOW_OWNER
model.NO_PARENT_AGENT.setTexture("Skin")
nameplate.ENTITY.setEnabled(false)
--========PHYSICS CONTROLS=========--
--not suggested to change these stuff :P
MARGIN = 0.01

--=================================--
last_position = vectors.of({})
position = vectors.of({})

last_body_rotation = 0
body_rotation = 0 -- Y axis only

last_head_rotation = vectors.of({})
head_rotation = vectors.of({})

velocity = vectors.of({})
--==========HELPY STUFFS===========--
is_on_floor = false
is_on_wall = false

distance_velocity = vectors.of({}) -- the distance of the velocity
distance_velocityXZ = vectors.of({}) -- velocity distance but only X and Z coordinates

distance_traveled = 0
distance_traveledXZ = 0 --distance traveled but only the X and Z coordinates 

time_since_agent_last_seen_owner = 0

--used to mimic entity arm or leg swinging
last_swing = 0
swing = 0

time_since_last_sync = 0 --multiplayer syncing physics
sync_time = 20 -- in Ticks

wander_time = 0
change_phase_at_time = 0
--=================================--
network.registerPing("wander")
network.registerPing("sync")

function player_init()
    renderer.setShadowSize(0)
    AGENT_PATH.setScale({AVATAR_SCALE,AVATAR_SCALE,AVATAR_SCALE})
    
end

function tick()
    simulate()
end

--if you wanna make your own avatar, just remove the code bellow to the --END mark, since all of these are for the default(player) agent


function behavior()
    last_body_rotation = body_rotation
    last_position = position
    last_head_rotation = head_rotation
    if client.isHost() then
        time_since_last_sync = time_since_last_sync + 1
    end

    distance_velocity = velocity.distanceTo(vectors.of({}))
    distance_velocityXZ = vectors.of({}).distanceTo(velocity*vectors.of({1,0,1}))

    distance_traveled = distance_traveled + distance_velocity
    distance_traveledXZ = distance_traveledXZ + distance_velocityXZ

    head_rotation = lookat(player.getPos(),position+TARGET_POSITION_OFFSET)+vectors.of({{-90,0,0}})

    if distance_velocityXZ > 0.1 then
        body_rotation = lookat(player.getPos(),position+TARGET_POSITION_OFFSET).y
        head_rotation = lookat(player.getPos(),position+TARGET_POSITION_OFFSET)+vectors.of({{-90,0,0}})
    else
        body_rotation = lerp_angle(body_rotation,head_rotation.y,0.1)
    end

    --if the distance is greater than DISTANCE_FOLLOW_OWNER, follow the owner
    if (position).distanceTo(player.getPos()+TARGET_POSITION_OFFSET) > DISTANCE_FOLLOW_OWNER then
        velocity = velocity + ((player.getPos()-(position+TARGET_POSITION_OFFSET))*vectors.of({1,0,1})).normalized()*WALK_SPEED
    end
    if is_on_wall then
        if is_on_floor then--jumpin
            velocity = vectors.of({0,JUMP_HEIGHT,0})
        end
    end

     -- classic unstuck strategy (faster but janky)
    if DISTANCE_BEFORE_TELEPORT_TO_OWNER < position.distanceTo(player.getPos()) then
        position = player.getPos()+(player.getLookDir()*vectors.of({1,0,1})).normalized()*-0.4
        last_position = position
        velocity = vectors.of({})
    end

     -- advance unstuck strategy (slower but better)
     -- this solves the problem where going inside the house but the agent is stuck outside,
    if renderer.raycastBlocks(position+vectors.of({0,EYE_HEIGHT,0}), player.getPos()+vectors.of({0,player.getEyeHeight()}), "COLLIDER", "NONE") then
        time_since_agent_last_seen_owner = time_since_agent_last_seen_owner + 1
        if time_since_agent_last_seen_owner > 20 then
            position = player.getPos()+(player.getLookDir()*vectors.of({1,0,1})).normalized()*-0.4
            
            last_position = position
        end
    else
        time_since_agent_last_seen_owner = 0
    end

    if world.getBlockState(position).name == "minecraft:water" then
        velocity = (velocity + vectors.of({0,0.12,0})) * vectors.of({0.9,1,0.9})
    end
    if client.isHost() then
        --wander_time = wander_time + 1
        if wander_time > change_phase_at_time then
            wander_time = 0
            network.ping("wander",vectors.of({0,0,0,lerp(MIN_TIME_WANDER,MAX_TIME_WANDER,math.random())})+vectors.of({lerp(-1,1,math.random()),0,lerp(-1,1,math.random())})*MAX_DISTANCE_WANDER)
        end
    end
    


    last_swing = swing
    swing = (math.sin(distance_traveledXZ*3)*math.max(math.min((distance_velocityXZ*5)-0.1,1),0))*45
end

--END

function simulate()
    behavior()

    is_on_wall = false
    local ray = renderer.raycastBlocks(position, position+velocity*vectors.of({1,0,0}), "COLLIDER", "NONE")
    if ray then--IF ON A WALL
        position = ray.pos + vectors.of({dotp(velocity.x)*-MARGIN,0,0})
        velocity = velocity*vectors.of({0,1,1})
        is_on_wall = true
    else
        position = position+velocity*vectors.of({1,0,0})
    end
    --AXIS Y
    velocity = vectors.of({velocity.x,velocity.y + GRAVITY,velocity.z})
    ray = renderer.raycastBlocks(position, position+velocity*vectors.of({0,1,0}), "COLLIDER", "NONE")
    if ray then--IF ON A WALL
        position = ray.pos + vectors.of({0,dotp(velocity.y)*-MARGIN,0})
        velocity = velocity*vectors.of({FRICTION,0,FRICTION})
        is_on_floor = true
    else
        is_on_floor = false
        if ALWAYS_HAVE_FRICTION then
            velocity = velocity*vectors.of({FRICTION,1,FRICTION})
            position = position+velocity*vectors.of({0,1,0})
        else
            position = position+velocity*vectors.of({0,1,0})
        end
    end
    --AXIS Z
    ray = renderer.raycastBlocks(position, position+velocity*vectors.of({0,0,1}), "COLLIDER", "NONE")
    if ray then--IF ON A WALL
        position = ray.pos + vectors.of({0,0,dotp(velocity.z)*-MARGIN})
        velocity = velocity*vectors.of({1,1,0})
        is_on_wall = true
    else
        position = position+velocity*vectors.of({0,0,1})
    end
    if client.isHost() then--physics syncing for multiplayer
        if time_since_last_sync > sync_time then
            time_since_last_sync = 0
            network.ping("sync",vectors.of({position.x,position.y,position.z,velocity.x,velocity.y,velocity.z}))
        end
    end
end

function sync(posvel)
    if not client.isHost then--only sync remote view
        position = vectors.of({posvel.x,posvel.y,posvel.z})
        velocity = vectors.of({posvel.w,posvel.t,posvel.h})
    end
end

function wander(data)
    change_phase_at_time = data.w
    TARGET_POSITION_OFFSET = data
end

function dotp(value)
    return value/math.abs(value)
end

function world_render(delta)
    if renderer.getCameraPos().distanceTo(position) < DISTANCE_BEFORE_STOP_POSE_MOVEMENT then
        model.NO_PARENT_AGENT.BODY.LL.setRot({lerp(last_swing,swing,delta),0,0})
        model.NO_PARENT_AGENT.BODY.LR.setRot({lerp(-last_swing,-swing,delta),0,0})
        model.NO_PARENT_AGENT.BODY.AL.setRot({lerp(-last_swing,-swing,delta),0,(math.sin(world.getTime()*0.08)*4)-4})
        model.NO_PARENT_AGENT.BODY.AR.setRot({lerp(last_swing,swing,delta),0,(math.sin(world.getTime()*0.08)*-4)+4})
        AGENT_HEAD.setRot(vectors.lerp(last_head_rotation,head_rotation,delta))
    end

    if position.distanceTo(renderer.getCameraPos()) < 32 then
        AGENT_PATH.setPos(vectors.lerp(last_position,position,delta)*vectors.of({-16,-16,16}))
        AGENT_BODY.setRot({0,lerp(last_body_rotation,body_rotation,delta)})
    end
end

function lookat(a,b)
    local offset = b-a
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end

function lerp(a, b, x)
    return a + (b - a) * x
end

function lerp_angle(a, b, x)
    local diff = (b-a)
    local delta = diff-(math.floor(diff/360)*360)
    if delta > 180 then
        delta = delta - 360
    end
    return a + delta * x
end
