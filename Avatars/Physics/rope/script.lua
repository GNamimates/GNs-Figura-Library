stick = {}
point = {}

sickLength = 1
itterations = 1000

--index all the parts

startupTimer = 10
startup = false
function simulation()
    if startup then
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
        point[1].pos = player.getPos()+vectors.of({0.3,2,1})
        --sticks
        for i = 1, 10, 1 do
            for key, stk in pairs(stick) do
                if stk.A ~= 0 and stk.B ~= 0 then
                    local center = (gp(stk.A).pos+gp(stk.B).pos) / 2
                    local dir = (gp(stk.A).pos-gp(stk.B).pos).normalized()
                    gp(stk.A).pos = center + dir * stk.length / 2
                    gp(stk.B).pos = center - dir * stk.length / 2
                end
            end
        end 
    end
end

function gp(id)--get point
    return point[id]
end

function tick()
    simulation()
    startupTimer = startupTimer - 1
    if startupTimer < 0 and not startup then
        
        startup = true
        if startup then
            local index = 0
            for key, value in pairs(model.NO_PARENT) do
                if string.match(key,"point") then
                    index = index + 1
                    table.insert(point,{
                        group=value,
                        pos=(value.getPivot()/16),
                        pivot=value.getPivot(),
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
                        length=11/16,
                        A=0,
                        B=0,
                    })
                end
            end
            --connect all this crap
            index = 0
            for stkName, stk in pairs(stick) do
                index = index + 1
                for pName, p in pairs(point) do
                    if p.pos.distanceTo(stk.group.getPivot()/16) < 0.01 then
                        stk.A = p.id
                    end
                    if p.pos.distanceTo((stk.group.getPivot()/16)+stk.group.worldToPartDir({0,-stk.length,0})) < 0.01 then
                        stk.B = p.id
                    end
                end
                --log((stk.group.getPivot()/16)+stk.group.worldToPartDir({0,-1,0}))
                --log("A"..stk.A.." | B"..stk.B)
            end
        end
    end
end

function world_render(delta)
    if startup then
        --render
        for key, p in pairs(point) do
            local point = p.group
            point.setPos((vectors.lerp(p.prevPos,p.pos,delta)-(p.pivot/16))*vectors.of({-16,-16,16})) 
        end
        for key, stk in pairs(stick) do
            if stk.A ~= 0 and stk.B ~= 0 then
                --log("A"..stk.A.." | B"..stk.B)
                stk.group.setPos((vectors.lerp(gp(stk.A).actualPrevPos,gp(stk.A).pos,delta)*vectors.of({-16,-16,16}))+(gp(stk.A).pivot))
                stk.group.setRot(lookat(vectors.lerp(gp(stk.A).actualPrevPos,gp(stk.A).pos,delta),vectors.lerp(gp(stk.B).prevPos,gp(stk.B).pos,delta)),delta)
            end
        end
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