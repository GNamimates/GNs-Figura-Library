cursorPos = vectors.of({0.5,43,0.5})
kinematicPos = vectors.of({0,0,0})

up = keybind.newKey("up","U")
down = keybind.newKey("down","J")
left = keybind.newKey("left","H")
right = keybind.newKey("right","K")

function tick()
    if up.isPressed() then
        cursorPos.y = cursorPos.y + 0.1
    end
    if down.isPressed() then
        cursorPos.y = cursorPos.y - 0.1
    end
    if left.isPressed() then
        cursorPos.x = cursorPos.x - 0.1
    end
    if right.isPressed() then
        cursorPos.x = cursorPos.x + 0.1
    end

    kinematicPos = collision(cursorPos)

    model.NO_PARENT.cursor.setPos({cursorPos.x*-16,cursorPos.y*-16,cursorPos.z*16})
    model.NO_PARENT.kinematic.setPos({kinematicPos.x*-16,kinematicPos.y*-16,kinematicPos.z*16})
end
--collision detection by GNamimates#9366
--give it a 3D position and it will return back the position but adjusted to the closest surface
function collision(pos)-- sorry idk what to name this lmao
    local point = vectors.of({pos.x,pos.y,pos.z})
    local collision = world.getBlockState(point).getCollisionShape()
    local blockPos = vectors.of({point.x-math.floor(point.x),point.y-math.floor(point.y),point.z-math.floor(point.z)})

    for index, value in ipairs(collision) do--loop through all the collision boxes
        if value.x < blockPos.x and value.w > blockPos.x then-- checks if inside the collision box
            if value.y < blockPos.y and value.t > blockPos.y then
                if value.z < blockPos.z and value.h > blockPos.z then
                    --detected inside the cube
                    local closest = 9999--used to see what is the closes face
                    local whoClosest = 0
                    local currentPoint = point--for somethin idk
                    --finding the closest surface from the cube
                    if math.abs(value.x-blockPos.x) < closest then
                        closest = math.abs(value.x-blockPos.x)
                        whoClosest = 0
                    end
                    if math.abs(value.y-blockPos.y) < closest then
                        closest = math.abs(value.y-blockPos.y)
                        whoClosest = 1
                    end
                    if math.abs(value.z-blockPos.z) < closest then
                        closest = math.abs(value.z-blockPos.z)
                        whoClosest = 2
                    end
                    
                    if math.abs(value.w-blockPos.x) < closest then
                        closest = math.abs(value.w-blockPos.x)
                        whoClosest = 3
                    end
                    if math.abs(value.t-blockPos.y) < closest then
                        closest = math.abs(value.t-blockPos.y)
                        whoClosest = 4
                    end
                    if math.abs(value.h-blockPos.z) < closest then
                        closest = math.abs(value.h-blockPos.z)
                        whoClosest = 5
                    end
                    --snap the closest surfance to the point
                    if whoClosest == 0 then
                        point.x = math.floor(currentPoint.x)+value.x
                    end
                    if whoClosest == 1 then
                        point.y = math.floor(currentPoint.y)+value.y
                    end
                    if whoClosest == 2 then
                        point.z = math.floor(currentPoint.z)+value.z
                    end
                    if whoClosest == 3 then
                        point.x =  math.floor(currentPoint.x)+value.w
                    end
                    if whoClosest == 4 then
                        point.y = math.floor(currentPoint.y)+value.t
                    end
                    if whoClosest == 5 then
                        point.z =  math.floor(currentPoint.z)+value.h
                    end
                end
            end
        end
    end
    return point
end