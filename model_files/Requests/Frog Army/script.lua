vectors.toWorld = vectors.of{-16,-16,16}

config = {
    gravity = vectors.of{0, -0.1, 0},
    wait_time_Range = {0.5, 5},
    distance_travel_range = {3, 10},--torus based distribution
    friction = 0.6,
    walk_speed = 0.1, -- meter/tick
    vanilla_walk_speed = 0.05, -- meter/tick, used when "vanilla_frog_animation" is true
    
    agent_count_cap = 100,-- inst
    outOfBoundsDistance = 128, -- when out of bounds, teleport agent to player

    vanilla_frog_animation = false,
}

targetUsername = nil

config.friction = vectors.of{config.friction,1,config.friction}

agents = {}

count = 1

function declareNewAgent()
    local c = tostring(count)
    table.insert(agents,{
        model = {
            base = model.NO_PARENT["frog"..c],
            LA = model.NO_PARENT["frog"..c]["left_arm"..c],
            RA = model.NO_PARENT["frog"..c]["right_arm"..c],
            LL = model.NO_PARENT["frog"..c]["left_leg"..c],
            RL = model.NO_PARENT["frog"..c]["right_leg"..c],
        },
        pos = player.getPos(),
        lastPos = player.getPos(),
        vel = vectors.of({0,0,0}),
        lastVel = vectors.of({0,0,0}),
        rot = 0,
        lastRot = 0,
        distTraveled = 0,
        lastDistTraveled = 0,
        distVel = 0,
        offsetTarget = vectors.of({0,0,0}),
        wanderTimer = 0,

        clickDelay = 0,
        clicksLeft = 0,

        daWaeTimes = 0,
        daWaeDelay = 0,
    })
    count = count + 1
end

function player_init()
    targetUsername = player.getName()
    for key = 1, config.agent_count_cap, 1 do
        if model.NO_PARENT["frog"..tostring(key)] then
            declareNewAgent()
        else
            break
        end
    end
end

function tick()
    local targetPos = player.getPos()
    local players = world.getPlayers()
    if players[targetUsername] then
        targetPos = players[targetUsername].getPos()
    end
    local targetPosFlat = targetPos * vectors.of{1,0,1}
    local finalWalkspeed = config.walk_speed
    if config.vanilla_frog_animation then
        finalWalkspeed = config.vanilla_walk_speed
    end
    for index, agent in pairs(agents) do
        agent.lastPos = agent.pos * 1
        agent.lastRot = agent.rot * 1
        agent.lastVel = agent.vel * 1
        agent.pos = agent.pos + agent.vel
        agent.vel = agent.vel * config.friction + config.gravity
        local col = collision(agent.pos)
        if col.isColliding and agent.pos.y-targetPos.y < 3 then
            agent.pos = col.pos
            agent.vel.y = 0.001
        end
        agent.distVel = (agent.vel*vectors.of{1,0,1}).getLength()
        agent.lastDistTraveled = agent.distTraveled * 1
        agent.distTraveled = agent.distTraveled + agent.distVel
        if agent.distVel > 0.01 then
            agent.rot = math.deg(-math.atan2(agent.vel.z, agent.vel.x))-90
        end

        if agent.distVel > 0.1 and col.isColliding and agent.pos.y-targetPos.y < 3 then
            if not config.vanilla_frog_animation then
                agent.vel.y = agent.vel.y + 0.3
            end
        end
        agent.wanderTimer = agent.wanderTimer - 1
        if agent.wanderTimer < 0 then
            agent.wanderTimer = math.lerp(config.wait_time_Range[1]*20, config.wait_time_Range[2]*20, math.random())
            agent.offsetTarget = vectors.of{math.lerp(-1,1,math.random()),0,math.lerp(-1,1,math.random())}.normalized()*math.lerp(config.distance_travel_range[1], config.distance_travel_range[2], math.random())
        end

        if agent.pos.distanceTo(targetPosFlat+agent.offsetTarget) > 2 then
            local offset = ((agent.pos-(targetPosFlat+agent.offsetTarget))*vectors.of{1,0,1}).normalized()*-finalWalkspeed
            agent.vel = agent.vel + vectors.of{
                offset.x,
                0,
                offset.z,
            }
        end
        if agent.pos.distanceTo(targetPos+agent.offsetTarget) > config.outOfBoundsDistance then
            agent.pos = targetPos+agent.offsetTarget
            agent.lastPos = targetPos+agent.offsetTarget
            agent.vel = vectors.of{0,0,0}
        end
    end
end

function world_render(delta)
    for index, agent in pairs(agents) do
        agent.model.base.setPos(vectors.lerp(agent.lastPos,agent.pos,delta)*vectors.toWorld)
        agent.model.base.setRot{math.lerp(agent.lastVel.y,agent.vel.y,delta)*45*math.min(agent.distVel*10,1),lerp_angle(agent.lastRot,agent.rot,delta)}
        if not config.vanilla_frog_animation then
            local swing = 0
            if agent.distVel > 0.1 then
                swing = math.sin(math.lerp(agent.lastDistTraveled,agent.distTraveled,delta)*5)*45
            end
            agent.model.LL.setRot{swing}
            agent.model.RL.setRot{-swing}
            agent.model.LA.setRot{-swing}
            agent.model.RA.setRot{swing}
        else
            walkFrog(index,(agent.distTraveled + delta * agent.distVel) * 15)
        end
    end
end


--=================================== ANIMATION =====================================--

function walkFrog(id,t)
    id = tostring(id)
    model.NO_PARENT["frog"..id]["body"..id].setRot({
        math.abs(math.sin(t)) * 2,
        math.sin(t + math.pi * 0.25) * 2,
        math.sin(t + math.pi * 0.5) * 6,
    })
    model.NO_PARENT["frog"..id]["right_leg"..id].setPos({0,
        math.min(math.sin(t),-0.01)*2,
        math.triangelWave(t/(math.pi * 2))*8 - 2 ,--(t%math.pi)
    })
    model.NO_PARENT["frog"..id]["right_leg"..id].setRot({
        math.max((t / math.pi % 2)-0.5,0) * 15
    })
    t = t + math.pi
    model.NO_PARENT["frog"..id]["left_leg"..id].setPos({0,
        math.min(math.sin(t),-0.01)*2,
        math.triangelWave(t/(math.pi * 2))*8 - 2 ,--(t%math.pi)
    })
    model.NO_PARENT["frog"..id]["left_leg"..id].setRot({
        math.max((t / math.pi % 2)-0.5,0) * 15
    })
    t = t - math.pi * 0.5
    model.NO_PARENT["frog"..id]["left_arm"..id].setPos({0,
        math.min(math.sin(t),-0.01)*2,
        math.triangelWave(t/(math.pi * 2))*8 - 1 ,--(t%math.pi)
    })
    model.NO_PARENT["frog"..id]["left_arm"..id].setRot({
        math.max((t / math.pi % 2)-0.5,0) * 15
    })
    t = t + math.pi
    model.NO_PARENT["frog"..id]["right_arm"..id].setPos({0,
        math.min(math.sin(t),-0.01)*2,
        math.triangelWave(t/(math.pi * 2))*8 - 1 ,--(t%math.pi)
    })
    model.NO_PARENT["frog"..id]["right_arm"..id].setRot({
        math.max((t / math.pi % 2)-0.5,0) * 15
    })
end

--=================================== EXTRAS =====================================--
function lerp_angle(a, b, x)
    local diff = (b-a)
    local delta = diff-(math.floor(diff/360)*360)
    if delta > 180 then
        delta = delta - 360
    end
    return a + delta * x
end

function collision(pos)
    local point = vectors.of({pos.x,pos.y,pos.z})
    local collision = world.getBlockState(point).getCollisionShape()
    local blockPos = vectors.of({point.x-math.floor(point.x),point.y-math.floor(point.y),point.z-math.floor(point.z)})
    local iscoll = false

    for index, value in ipairs(collision) do--loop through all the collision boxes
        if value.x < blockPos.x and value.w > blockPos.x then-- checks if inside the collision box
            if value.y < blockPos.y and value.t > blockPos.y then
                if value.z < blockPos.z and value.h > blockPos.z then
                    --detected inside the cube
                    local currentPoint = point--for somethin idk
                    --finding the closest surface from the cube
                    point.y = math.floor(currentPoint.y)+value.t
                    iscoll = true
                end
            end
        end
    end
    return {pos=point,isColliding=iscoll}
end

timer = {}

function Delay(time,func)
    table.insert(timer,{time=time,func=func})
end

function tick()
    for key, value in pairs(timer) do
        value.time = value.time - 1
        if value.time <= 0 then
            value.func()
            table.remove(timer,key)
        end
    end
end

function math.triangelWave(x)
    return math.clamp(math.floor(x % 1 + 0.5) + ((x % 1)* 2) * -(math.floor(x % 1 + 0.5) - 0.5),0,1)
end