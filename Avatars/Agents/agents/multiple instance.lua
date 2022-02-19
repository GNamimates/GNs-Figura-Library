position = {}
velocity = {}
targetRotation = {}
distanceWalked = {}
distVelocity = {}
offsetTarget = {}
wanderTimer = {}

local agents = {}
local agentname
for i=1,200 do
    agentname = "agent" .. i
    local base = model.NO_PARENT[agentname]
    agents[i] = {
    base = base,
    B = base["B"..i],
    H = base["H"..i],
    LA = base["B"..i]["LA"..i],
    RA = base["B"..i]["RA"..i],
    LL = base["B"..i]["LL"..i],
    RL = base["B"..i]["RL"..i],
  }
end

finishedLoading = false
function player_init()
    for key, value in pairs(agents) do
        value.base.setScale({0.95,0.95,0.95})
        position[key] = player.getPos()
        declareNewAgentStats()
    end
    finishedLoading = true
end

function tick()
    if finishedLoading then
        for key, value in pairs(agents) do
            position[key] = position[key] + velocity[key]
            velocity[key] = velocity[key] * vectors.of({0.6,1,0.6})
    
            local coll = collision(position[key])
            position[key] = coll.position
            velocity[key] = velocity[key] + vectors.of({0,-0.08})
    
            if coll.isColliding then
                velocity[key].y = 0.0001
            end
            local distanceToPlayer = vectors.of({position[key].x,0,position[key].z}).distanceTo((vectors.of({player.getPos().x,0,player.getPos().z})+offsetTarget[key]))
            if distanceToPlayer > 1 then
                local movement = (player.getPos()-position[key]+offsetTarget[key]).normalized()*0.1
                
                if distanceToPlayer > 5 then
                    movement = (player.getPos()-position[key]+offsetTarget[key]).normalized()*0.15
                    if coll.isColliding then
                        velocity[key].y = 0.4
                    end
                end
                velocity[key] = velocity[key] + vectors.of({movement.x,0,movement.z})
            end
            
            if world.getBlockState(position[key]+vectors.of({0,0.5,0})).name == "minecraft:water" then
                velocity[key] = velocity[key] * vectors.of({0.7,0.8,0.7})
                velocity[key] = velocity[key] + vectors.of({0,0.1,0})
            end

            distVelocity[key] = vectors.of({}).distanceTo(vectors.of({velocity[key].x,0,velocity[key].z}))
            distanceWalked[key] = distanceWalked[key] + distVelocity[key]

            if wanderTimer[key] < 0 then
                wanderTimer[key] = math.random()*20*5
                offsetTarget[key] = vectors.of({math.random()*50-25,0,math.random()*50-25})
            end
            wanderTimer[key] = wanderTimer[key] - 1
        end
    end
end

function world_render(delta)
    if finishedLoading then
        for key, value in pairs(agents) do
            value.base.setPos(vectors.lerp(value.base.getPos(),vectors.of({position[key].x*-16,position[key].y*-16,position[key].z*16}),delta))

            if velocity[key].distanceTo(vectors.of({})) > 0.01 then
                value.B.setRot({0,lerp_angle(value.B.getRot().y,math.deg(math.atan2(velocity[key].x,velocity[key].z))+180,delta)})
            end
            local lukat = velocity[key] * vectors.of({-1,-1,-1})

            targetRotation[key] = vectors.of({0,math.deg(math.atan2(lukat.x,lukat.z)),0})
            value.H.setRot({
                lerp_angle(value.H.getRot().x,targetRotation[key].x,delta),
                lerp_angle(value.H.getRot().y,targetRotation[key].y,delta),
                lerp_angle(value.H.getRot().z,targetRotation[key].z,delta)})
            local swing = (math.sin(distanceWalked[key]*2.3)*45)*math.min(distVelocity[key]*32,1)
            value.LL.setRot({lerp(value.LL.getRot().x,swing,delta)})
            value.RL.setRot({lerp(value.RL.getRot().x,-swing,delta)})
            value.LA.setRot({lerp(value.LA.getRot().x,swing,delta)})
            value.RA.setRot({lerp(value.RA.getRot().x,-swing,delta)})
        end
    end
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

--for future plans
function declareNewAgentStats()
    table.insert(position,vectors.of({0,0,0}))
    table.insert(velocity,vectors.of({0,0,0}))
    table.insert(targetRotation,vectors.of({0,0,0}))
    table.insert(distanceWalked,0)
    table.insert(distVelocity,0)
    table.insert(offsetTarget,vectors.of({0,0,0}))
    table.insert(wanderTimer,0)
end

--collision detection by GNamimates#9366
--give it a 3D position and it will return back the position but adjusted to the closest surface
function collision(pos)-- sorry idk what to name this lmao
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
    return {position=point,isColliding=iscoll}
end