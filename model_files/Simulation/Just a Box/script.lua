
points = {}
constraints = {}

config = {
    gravity = vectors.of{0,-0.02,0},
    margin = 0.05, -- used to prevent points from being stuck in walls, recommended to be 0.05 
    friction = 0.7,
    
    itteration = 5, -- how many times to iterate the point solver, higher values = more accurate but slower

    constraint_particle_subdivision = 4,

    point_select_radius = 0.1,
}

config.constraint_particle_subdivision = 1/config.constraint_particle_subdivision


vectors.world = vectors.of{-16,-16,16}

selectedPoint = 0
distanceHeld = 1
grabKey = keybind.newKey("Grab","MOUSE_BUTTON_2")
wasGrabbing = false

function newPoint(pos,vel,locked)
    local index = #points+1
    points[index] = {
        pos = vectors.of{pos}+player.getPos(),
        prevPos = pos,
        vel = vectors.of{vel},
        locked = locked,
    }
    return points[index]
end

function newConstraint(a,b,length)
    local index = #constraints+1
    constraints[index] = {
        a_id = a,
        b_id = b,
        length = length,
    }
end

function player_init()
    newPoint({0,2,0},{0,0,0},false)
    newPoint({0,1,0},{0,1,0},false)
    newPoint({0,1,1},{0,0,0},false)
    newPoint({0,2,1},{0,0,0},false)

    newPoint({1,2,0},{0,0,0},false)
    newPoint({1,1,0},{0,0,0},false)
    newPoint({1,1,1},{0,0,0},false)
    newPoint({1,2,1},{0,0,0},false)

    newConstraint(1,2,1)
    newConstraint(2,3,1)
    newConstraint(3,4,1)
    newConstraint(4,1,1)

    newConstraint(5,6,1)
    newConstraint(6,7,1)
    newConstraint(7,8,1)
    newConstraint(8,5,1)

    newConstraint(1,5,1)
    newConstraint(2,6,1)
    newConstraint(3,7,1)
    newConstraint(4,8,1)

    newConstraint(1,3,1.414214)
    newConstraint(4,2,1.414214)

    newConstraint(5,7,1.414214)
    newConstraint(8,6,1.414214)

    newConstraint(1,6,1.414214)
    newConstraint(2,5,1.414214)

    newConstraint(3,8,1.414214)
    newConstraint(4,7,1.414214)

    newConstraint(1,8,1.414214)
    newConstraint(4,5,1.414214)

    newConstraint(3,6,1.414214)
    newConstraint(7,2,1.414214)

    --newPoint({0,2,0},{0,0,0},true)
    --newPoint({1,2,0},{0,0,0},true)
    --newPoint({2,2,0},{0,0,0},true)
    --newPoint({3,2,0},{0,0,0},true)
end

ping.syncGrab = function (data)
    isPressed = data.toggle
    selectedPoint = data.selectedPoint
end

function tick()
    if client.isHost() then
        isPressed = grabKey.isPressed()
    end
    if isPressed ~= wasGrabbing then
        if client.isHost() then
            if isPressed then
                selectedPoint = raycastFindPoint(player.getPos()+vectors.of{0,player.getEyeHeight()},player.getLookDir()*0.1)
            end
            ping.syncGrab({toggle=isPressed,selectedPoint=selectedPoint})
        end
        if isPressed then
            if selectedPoint then
                distanceHeld = (points[selectedPoint].pos-(player.getPos()+vectors.of{0,player.getEyeHeight()})).getLength()
            end
        end
    end
    if isPressed then
        if selectedPoint then
            local targetPos = player.getPos()+vectors.of{0,player.getEyeHeight()}+player.getLookDir()*distanceHeld
            if points[selectedPoint].locked then
                points[selectedPoint].pos = targetPos
            else
                points[selectedPoint].vel = (targetPos-points[selectedPoint].pos) * 2
            end
        end
    end
    wasGrabbing = isPressed
    local timeScale = 1/config.itteration
    for itteration = 1, config.itteration, 1 do
        for _, c in pairs(constraints) do
            local a = points[c.a_id]
            local b = points[c.b_id]
            local dir = (b.pos-a.pos).normalized()
            local length = (b.pos-a.pos).getLength()
            local diff = length - c.length
            local diff_dir =  dir * diff
            if not a.locked then
                local last_a = a.pos
                a.pos = a.pos + diff_dir / 2
                a.vel = a.vel + (a.pos - last_a)
            end
            if not b.locked then
                local last_b = b.pos
                b.pos = b.pos - diff_dir / 2
                b.vel = b.vel + (b.pos - last_b)
            end
            --if i == 0 then
            --    for weight = 0, math.floor(c.length), config.constraint_particle_subdivision do
            --        particle.addParticle("minecraft:bubble",vectors.lerp(a.pos,b.pos,weight))
            --    end
            --end
        end
        for i, p in pairs(points) do
            if itteration == 1 then
                p.prevPos = p.pos * 1
            end
            if not p.locked then
                do
                    p.pos.x = p.pos.x + p.vel.x * timeScale
                    p.vel.x = p.vel.x + config.gravity.x * timeScale
                    local c = collision(p.pos,0)
                    if c.isColliding then
                        p.pos.x = c.result.x
                        p.vel.x = 0
                        p.vel.y = p.vel.y * config.friction * timeScale
                        p.vel.z = p.vel.z * config.friction * timeScale
                    end
                end
                do
                    p.pos.y = p.pos.y + p.vel.y * timeScale
                    p.vel.y = p.vel.y + config.gravity.y * timeScale
                    local c = collision(p.pos,1)
                    if c.isColliding then
                        p.pos.y = c.result.y
                        p.vel.y = 0
                        p.vel.x = p.vel.x * config.friction * timeScale
                        p.vel.z = p.vel.z * config.friction * timeScale
                    end
                end
                do
                    p.pos.z = p.pos.z + p.vel.z * timeScale
                    p.vel.z = p.vel.z + config.gravity.z * timeScale
                    local c = collision(p.pos,2)
                    if c.isColliding then
                        p.pos.z = c.result.z
                        p.vel.z = 0
                        p.vel.x = p.vel.x * config.friction * timeScale
                        p.vel.y = p.vel.y * config.friction * timeScale
                    end
                end
            end
        end
    end
end

function world_render(delta)
    for i, p in pairs(points) do
        model.NO_PARENT["p"..tostring(i)].setPos(vectors.lerp(p.prevPos,p.pos,delta)*vectors.world)
    end
    for i, c in pairs(constraints) do
        local a = points[c.a_id]
        local b = points[c.b_id]
        model.NO_PARENT["c"..tostring(i)].setPos(vectors.lerp(a.prevPos,a.pos,delta)*vectors.world)
        model.NO_PARENT["c"..tostring(i)].setRot(vectors.toAngle(vectors.lerp(b.prevPos,b.pos,delta)-vectors.lerp(a.prevPos,a.pos,delta)))
        model.NO_PARENT["c"..tostring(i)].setScale(vectors.of{1,c.length,1})
    end
end

function raycastFindPoint(pos,dir)
    local found = 0
    for i = 1, 100, 1 do
        pos = pos + dir
        found = findSelectedPoint(pos)
        if found then
            return found
        end
    end
end

function findSelectedPoint(pos)
    local closest = {
        id = nil,
        dist = math.huge,
    }
    for i, p in pairs(points) do
        local dist = (p.pos-pos).getLength()
        if dist < closest.dist and dist < config.point_select_radius then
            --log(i.." |  "..tostring(dist))
            closest = {
                id = i,
                dist = dist,
            }
        end
    end
    return closest.id
end

function collision(pos,axis)-- sorry idk what to name this lmao
    local isColliding = false
    local collisionShape = world.getBlockState(pos).getCollisionShape()--I HATE YELLOW(update, no more yellow :D)
    local blockPos = vectors.of({pos.x-math.floor(pos.x),pos.y-math.floor(pos.y),pos.z-math.floor(pos.z)})
    for _, face in ipairs(collisionShape) do--loop through all the collision boxes
        if face.x < blockPos.x and face.w > blockPos.x then-- checks if inside the collision box
            if face.y < blockPos.y and face.t > blockPos.y then
                if face.z < blockPos.z and face.h > blockPos.z then
                    local currentPoint = pos--for somethin idk
                    isColliding = true
                    if axis == 0 then
                        if math.abs(blockPos.x-face.x) > math.abs(blockPos.x-face.w) then
                            pos.x = math.floor(pos.x) + face.w + config.margin
                        else
                            pos.x = math.floor(pos.x) + face.x - config.margin
                        end
                        break
                    end
                    if axis == 1 then
                        if math.abs(blockPos.y-face.y) > math.abs(blockPos.y-face.t) then
                            pos.y = math.floor(pos.y) + face.t + config.margin
                        else
                            pos.y = math.floor(pos.y) + face.y - config.margin
                        end
                        break
                    end
                    if axis == 2 then
                        if math.abs(blockPos.z-face.z) > math.abs(blockPos.z-face.h) then
                            pos.z = math.floor(pos.z) + face.h + config.margin
                        else
                            pos.z = math.floor(pos.z) + face.z - config.margin
                        end
                        break
                    end
                end
            end
        end
    end
    return {result=pos,isColliding=isColliding}
end

function vectors.toAngle(pos)
    local y = math.atan2(pos.x,pos.z)
    local result = vectors.of({math.atan2((math.sin(y)*pos.x)+(math.cos(y)*pos.z),pos.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end