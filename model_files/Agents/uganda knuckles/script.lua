--[[--====================================================================---------
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
--=================================================================================--
Libs Used:

- Balls
]]--===============================================================================--
vectors.toWorld = vectors.of{-16,-16,16}

config = {
    gravity = vectors.of{0, -0.1, 0},
    waitTimeRange = {0.5, 5},
    distanceTravelRange = {3, 9},--torus based distribution
    friction = 0.6,
    walkSpeed = 0.1, -- meter/tick
    
    agentCountCap = 30,-- inst

    clickDelayRange = {0.1,1},-- sec
    clickCount = 5,

    daWaeDelayRange = {0.7, 0.8},-- sec
    daWaeCount = 3,
    
}

targetUsername = nil

config.friction = vectors.of{config.friction,1,config.friction}

agents = {}

count = 1

action_wheel.SLOT_1.setItem("crimson_planks")
action_wheel.SLOT_1.setTitle("*Clicking Noises*")
action_wheel.SLOT_1.setFunction(function ()
    ping.click()
end)

ping.click = function ()
    for index, agent in pairs(agents) do
        agent.clicksLeft = config.clickCount
    end
end

action_wheel.SLOT_2.setItem("bell")
action_wheel.SLOT_2.setTitle("*What do we want*")
action_wheel.SLOT_2.setFunction(function ()
    ping.dawe()
end)

ping.dawe = function ()
    sound.playCustomSound("what do we want",player.getPos(),{1,1})
    Delay(30,daWae)
end

function daWae()
    for index, agent in pairs(agents) do
        agent.daWaeTimes = config.daWaeCount
    end
end

function declareNewAgent()
    table.insert(agents,{
        model = {
            base = model["NO_PARENT_UGANDA"..tostring(count)],
             H = model["NO_PARENT_UGANDA"..tostring(count)]["H"..tostring(count)],
            LA = model["NO_PARENT_UGANDA"..tostring(count)]["LArm"..tostring(count)],
            RA = model["NO_PARENT_UGANDA"..tostring(count)]["RArm"..tostring(count)],
            LL = model["NO_PARENT_UGANDA"..tostring(count)]["LLeg"..tostring(count)],
            RL = model["NO_PARENT_UGANDA"..tostring(count)]["RLeg"..tostring(count)],
            M = model["NO_PARENT_UGANDA"..tostring(count)]["H"..tostring(count)]["M"..tostring(count)],
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
    for key = 1, config.agentCountCap, 1 do
        if model["NO_PARENT_UGANDA"..tostring(key)] then
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
    local targetHeight = targetPos.y
    targetPos = targetPos * vectors.of{1,0,1}

    for index, agent in pairs(agents) do
        agent.lastPos = agent.pos * 1
        agent.lastRot = agent.rot * 1
        agent.lastVel = agent.vel * 1
        agent.pos = agent.pos + agent.vel
        agent.vel = agent.vel * config.friction + config.gravity
        local col = collision(agent.pos)
        if col.isColliding and agent.pos.y-targetHeight < 3 then
            agent.pos = col.pos
            agent.vel.y = 0.001
        end
        agent.distVel = (agent.vel*vectors.of{1,0,1}).getLength()
        agent.lastDistTraveled = agent.distTraveled * 1
        agent.distTraveled = agent.distTraveled + agent.distVel
        if agent.distVel > 0.01 then
            agent.rot = math.deg(-math.atan2(agent.vel.z, agent.vel.x))-90
        end

        if agent.distVel > 0.1 and col.isColliding and agent.pos.y-targetHeight < 3 then
            agent.vel.y = agent.vel.y + 0.3
        end
        agent.wanderTimer = agent.wanderTimer - 1
        if agent.wanderTimer < 0 then
            agent.wanderTimer = math.lerp(config.waitTimeRange[1]*20, config.waitTimeRange[2]*20, math.random())
            agent.offsetTarget = vectors.of{math.lerp(-1,1,math.random()),0,math.lerp(-1,1,math.random())}.normalized()*math.lerp(config.distanceTravelRange[1], config.distanceTravelRange[2], math.random())
        end

        if agent.pos.distanceTo(targetPos+agent.offsetTarget) > 2 then
            local offset = ((agent.pos-(targetPos+agent.offsetTarget))*vectors.of{1,0,1}).normalized()*-config.walkSpeed 
            agent.vel = agent.vel + vectors.of{
                offset.x,
                0,
                offset.z,
            }
        end
        agent.model.M.setRot({})
        if agent.clicksLeft > 0 then
            agent.clickDelay = agent.clickDelay - 1
            if agent.clickDelay < 0 then
                agent.clickDelay = math.lerp(config.clickDelayRange[1]*20, config.clickDelayRange[2]*20, math.random())
                agent.clicksLeft = agent.clicksLeft - 1
                click(agent.pos)
                agent.model.M.setRot({15})
            end
        end
        if agent.daWaeTimes > 0 then
            agent.daWaeDelay = agent.daWaeDelay - 1
            if agent.daWaeDelay < 0 then
                agent.daWaeDelay = math.lerp(config.daWaeDelayRange[1]*20, config.daWaeDelayRange[2]*20, math.random())
                agent.daWaeTimes = agent.daWaeTimes - 1
                audioTheWay(agent.pos)
                agent.model.M.setRot({15})
                agent.vel.y = 0.4
            end
        end
    end
end

function world_render(delta)
    for index, agent in pairs(agents) do
        agent.model.base.setPos(vectors.lerp(agent.lastPos,agent.pos,delta)*vectors.toWorld)
        agent.model.base.setRot{math.lerp(agent.lastVel.y,agent.vel.y,delta)*-45*math.min(agent.distVel*10,1),lerp_angle(agent.lastRot,agent.rot,delta)}
        local swing = 0
        if agent.distVel > 0.1 then
            swing = math.sin(math.lerp(agent.lastDistTraveled,agent.distTraveled,delta)*5)*45
        end
        agent.model.LL.setRot{swing}
        agent.model.RL.setRot{-swing}
        agent.model.LA.setRot{-swing}
        agent.model.RA.setRot{swing}
    end
end
--=================================== STUPID STUFF ===================================--
function click(pos)
    local random = math.random()
    sound.playCustomSound("click"..tostring(math.floor(random*2+1.5)),player.getPos(),{0.5,math.lerp(0.8,1.2,math.random())})
end

function audioTheWay(pos)
    local random = math.random()
    sound.playCustomSound("the way"..tostring(math.floor(random*2+1.5)),player.getPos(),{0.5,math.lerp(0.8,1.2,math.random())})
end

chat.setFiguraCommandPrefix("follow")

function onCommand(cmd)
    local Username = string.sub(cmd,8,#cmd)
    if Username == "me" then
        Username = player.getName()
    else
        local players = world.getPlayers()
        for name, _ in pairs(players) do
            if name == Username then
                ping.target(Username)
                
            end
        end
    end
end

ping.target = function (target)
    targetUsername = target
    if client.isHost() then
        log('§afollowing "'..target..'"')
    end
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