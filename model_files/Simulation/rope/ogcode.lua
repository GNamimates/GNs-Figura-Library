stick = {}
point = {}

sickLength = 1
itterations = 1000

attack = keybind.getRegisteredKeybind("key.attack")

local index = 0
for key, value in pairs(model.NO_PARENT) do
    index = index + 1
    if string.match(key,"point") then
        table.insert(point,{
            group=value,
            pos=vectors.of({}),
            prevPos=vectors.of({}),
            isLocked=false,
            id=index,
            actualPrevPos=vectors.of({})
        })
    end
    if string.match(key,"stick") then
        table.insert(stick,{
            group=value,
            pos = vectors.of({}),
            A=tonumber(string.sub(key,6,999)),
            B=tonumber(string.sub(key,6,999))+1,
        })
    end
end

function simulation()
    --points
    for key, p in pairs(point) do
        local posBeforeUpdate = p.pos
        local actualPrevPos = p.pos
        p.pos = p.pos+p.pos - p.prevPos
        p.pos = p.pos + vectors.of({0,-0.02,0})
        local col = collision(p.pos)
        p.pos = col.result
        if col.isColliding then
            posBeforeUpdate = (posBeforeUpdate-p.pos)*0.5+p.pos
        end
        p.prevPos = posBeforeUpdate
        p.actualPrevPos = actualPrevPos
    end
    point[1].pos = player.getPos()+vectors.of({1,2,1})
    --sticks
    for i = 1, 10, 1 do
        for key, stk in pairs(stick) do
            local center = (point[stk.A].pos+point[stk.B].pos) / 2
            local dir = (point[stk.A].pos-point[stk.B].pos).normalized()
            point[stk.A].pos = center + dir * sickLength / 2
            point[stk.B].pos = center - dir * sickLength / 2
        end
    end 
end

function tick()
    simulation()
    if attack.isPressed() then
        point[2].prevPos = point[2].pos-player.getLookDir()
    end
end

function world_render(delta)
    --render
    for key, p in pairs(point) do
        local point = p.group
        point.setPos(vectors.lerp(p.prevPos,p.pos,delta)*vectors.of({-16,-16,16})) 
    end
    for key, stk in pairs(stick) do
        stk.group.setPos(vectors.lerp(point[stk.A].actualPrevPos,point[stk.A].pos,delta)*vectors.of({-16,-16,16}))
        stk.group.setRot(lookat(vectors.lerp(point[stk.A].actualPrevPos,point[stk.A].pos,delta),vectors.lerp(point[stk.B].prevPos,point[stk.B].pos,delta)),delta)
    end
end

function lerp(a, b, x)
    return a + (b - a) * x
end

function lookat(a,b)
    local offset = b-a
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end


--collision detection by GNamimates#9366
--give it a 3D position and it will return back the position but adjusted to the closest surface
function collision(pos)-- sorry idk what to name this lmao
    player.getLookDir()
    local isColliding = false
    local point = vectors.of({pos.x,pos.y,pos.z})
    local collision = world.getBlockState(point).getCollisionShape()--I HATE YELLOW
    local blockPos = vectors.of({point.x-math.floor(point.x),point.y-math.floor(point.y),point.z-math.floor(point.z)})

    for index, value in ipairs(collision) do--loop through all the collision boxes
        if value.x < blockPos.x and value.w > blockPos.x then-- checks if inside the collision box
            if value.y < blockPos.y and value.t > blockPos.y then
                if value.z < blockPos.z and value.h > blockPos.z then
                    local currentPoint = point--for somethin idk
                    point.y =  math.floor(currentPoint.y)+value.t
                    isColliding = true
                end
            end
        end
    end
    return {result=point,isColliding=isColliding}
end

function toLocalCoord(pos,rot)
    model.NO_PARENT.partToWorldPos()
    return vectors.of(
        {
            ((math.sin(math.rad(-rot.y))*pos.z)+(math.cos(math.rad(rot.y))*pos.x))*(math.cos(math.rad(rot.x))),
            (math.sin(math.rad(-rot.x))*pos.z)+(math.cos(math.rad(rot.x))*pos.z),
            ((math.cos(math.rad(-rot.y))*pos.z)+(math.sin(math.rad(rot.y))*pos.x))*(math.cos(math.rad(rot.x))),
        }
    )
end
