--[[--====================================================================---------
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
--=================================================================================--]]
model.NO_PARENT.setEnabled(false)
towrld = vectors.of{-16,-16,16}

idrot = {
    {90,-90,0},
    {180,0,0},
    {90,180,0},
    {90,90,0},
    {0,0,0},
    {90,0,0},
}

normalIndex = {
    vectors.of{-1,0,0},
    vectors.of{0,-1,0},
    vectors.of{0,0,-1},
    vectors.of{1,0,0},
    vectors.of{0,1,0},
    vectors.of{0,0,1},
}

absNormalIndex = {
    vectors.of{1,0,0},
    vectors.of{0,1,0},
    vectors.of{0,0,1},
    vectors.of{1,0,0},
    vectors.of{0,1,0},
    vectors.of{0,0,1},
}

inverseNormalIndex = {
    vectors.of{0,1,1},
    vectors.of{1,0,1},
    vectors.of{1,1,0},
    vectors.of{0,1,1},
    vectors.of{1,0,1},
    vectors.of{1,1,0},
}

offsetIndex = {
    vectors.of{0,0,0},
    vectors.of{0,0,0},
    vectors.of{0,0,0},
    vectors.of{1,0,0},
    vectors.of{0,1,0},
    vectors.of{0,0,1},
}

idinvnorm = {
    {0,1,0},
    {1,0,0},
    {0,1,0},
    {0,1,0},
    {1,0,0},
    {0,1,0},
}

interact = {
    keybind = keybind.newKey("Primary","MOUSE_BUTTON_2"),
    isPressed = false,
    wasPressed = false,
}

--actual selection positions and normals
initRay = nil

modes = {
    select = 0,
    extrude = 1,
}

Mode = modes.select

areaStart = nil
aNormal = nil
areaScale = nil
areaCenter = nil

extrudeHeight = 0
areaExtrudePos = nil
areaExtrudeScale = nil

function world_render(delta)
    local origin = player.getPos(delta)+vectors.of{0,player.getEyeHeight()}
    local ray = renderer.raycastBlocks(origin,origin+player.getLookDir()*10,"VISUAL","NONE")
    local dir = player.getLookDir()--gets the camera dir, not the player dir
    local blockPos = nil
    interact.isPressed = interact.keybind.isPressed()

    if ray then
        blockPos = vectors.of{math.floor(ray.pos.x+dir.x*0.001),math.floor(ray.pos.y+dir.y*0.001),math.floor(ray.pos.z+dir.z*0.001)}
        local faceCenter, whoClosest = getClosestFace(ray.pos+dir*0.001)
        if whoClosest then
            model.NO_PARENT.setPos(faceCenter*towrld) 
        end
        if interact.wasPressed ~= interact.isPressed then
            if interact.isPressed then
                if Mode == modes.select then
                    areaStart = blockPos
                    aNormal = whoClosest
                    initRay = blockPos+offsetIndex[aNormal+1]
                end
            end
        end
    end
    if areaStart then
        if interact.isPressed then
            if Mode == modes.select then
                areaScale = rayToPlane(origin-initRay,dir,normalIndex[aNormal+1],0)
                areaScale = vectors.of{math.floor(areaScale.x),math.floor(areaScale.y),math.floor(areaScale.z)}
            end
            if Mode == modes.extrude then
                extrudeHeight = rayToPlane(origin-areaCenter,dir,(areaCenter-origin)*inverseNormalIndex[aNormal+1],0)
                extrudeHeight = extrudeHeight * absNormalIndex[aNormal+1]
                extrudeHeight = vectors.of{math.floor(extrudeHeight.x),math.floor(extrudeHeight.y),math.floor(extrudeHeight.z)}

                areaExtrudePos = vectors.of{
                    areaStart.x+areaScale.x*offsetIndex[aNormal+1].x,
                    areaStart.y+areaScale.y*offsetIndex[aNormal+1].y,
                    areaStart.z+areaScale.z*offsetIndex[aNormal+1].z,
                }
                
                areaExtrudeScale = areaScale + extrudeHeight

                updateSelectionArea(areaExtrudePos,areaExtrudeScale)
            end
        end
        if interact.wasPressed ~= interact.isPressed then
            if not interact.isPressed then
                if areaStart and areaScale and Mode == modes.select then
                    selectionSwizzle()
                    Mode = modes.extrude
                else
                    Mode = modes.select
                end
            end
        end
    end

    interact.wasPressed = interact.isPressed
    
    if areaStart then
        if areaScale and interact.isPressed and Mode == modes.select then
            updateSelectionArea(areaStart,areaScale)
            areaCenter = areaStart+areaScale/2
        end
    end
end

-->========================================[ ugly math ]=========================================<--

function raycast(pos,dir)
    local margin = 0.001
    local ray1 = renderer.raycastBlocks(pos,pos+dir*100,"OUTLINE","NONE")
    local offset = vectors.of{margin,margin,margin}
    local ray2 = renderer.raycastBlocks(pos+offset,pos+dir*100+offset,"OUTLINE","NONE")
    if ray1 and ray2 then--lazy check lmao
        pos = ray1.pos
        local diff = ray1.pos-ray2.pos
        if math.abs(diff.x) < math.abs(diff.y) and math.abs(diff.x) < math.abs(diff.z) then
            return vectors.of{1,0,0},1, pos+dir*margin, dir
        elseif math.abs(diff.y) < math.abs(diff.x) and math.abs(diff.y) < math.abs(diff.z) then
            return vectors.of{0,1,0},2, pos+dir*margin, dir
        else
            return vectors.of{0,0,1},3, pos+dir*margin, dir
        end
    end
end

function rayToPlane(rayOrigin,rayDir,planeNormal,planeDist)
    local denom = vectors.dot(planeNormal,rayDir)
    if denom == 0 then
        return nil
    end
    local t = -vectors.dot(planeNormal,rayOrigin)+planeDist
    t = t/denom
    return rayOrigin+rayDir*t
end

function vectors.sepNormalize(pos)--normalizes each axis seperately,
    pos = pos * 1
    if pos.x ~= 0 then
        pos.x = pos.x/math.abs(pos.x)
    end
    if pos.y ~= 0 then
        pos.y = pos.y/math.abs(pos.y)
    end
    if pos.z ~= 0 then
        pos.z = pos.z/math.abs(pos.z)
    end
    return pos
end

function vectors.dot(a,b)
    return a.x*b.x+a.y*b.y+a.z*b.z
end

-->========================================[ other ]=========================================<--

function getClosestFace(pos)
    local blockPos = vectors.of{math.floor(pos.x),math.floor(pos.y),math.floor(pos.z)}
    local collision = world.getBlockState(pos).getCollisionShape()--getting block collision
    local modBlock = vectors.of({pos.x-math.floor(pos.x),pos.y-math.floor(pos.y),pos.z-math.floor(pos.z)})--block modulo position
    local whoClosest = 0
    for _, value in ipairs(collision) do--loop through all the collision boxes
        local blockCenter = vectors.of{
            math.lerp(value.x,value.w,0.5),
            math.lerp(value.y,value.t,0.5),
            math.lerp(value.z,value.h,0.5)
        }
        if value.x <= modBlock.x and value.w >= modBlock.x then-- checks if inside the collision box
            if value.y <= modBlock.y and value.t >= modBlock.y then
                if value.z <= modBlock.z and value.h >= modBlock.z then
                    --detected inside the cube
                    local closest = 9999--used to see what is the closes face
                    
                    local currentPoint = pos--for somethin idk
                    --finding the closest surface from the cube
                    if math.abs(value.x-modBlock.x) < closest then
                        closest = math.abs(value.x-modBlock.x)
                        whoClosest = 0
                    end
                    if math.abs(value.y-modBlock.y) < closest then
                        closest = math.abs(value.y-modBlock.y)
                        whoClosest = 1
                    end
                    if math.abs(value.z-modBlock.z) < closest then
                        closest = math.abs(value.z-modBlock.z)
                        whoClosest = 2
                    end
                    
                    if math.abs(value.w-modBlock.x) < closest then
                        closest = math.abs(value.w-modBlock.x)
                        whoClosest = 3
                    end
                    if math.abs(value.t-modBlock.y) < closest then
                        closest = math.abs(value.t-modBlock.y)
                        whoClosest = 4
                    end
                    if math.abs(value.h-modBlock.z) < closest then
                        closest = math.abs(value.h-modBlock.z)
                        whoClosest = 5
                    end
                    pos = vectors.of{blockCenter.x,blockCenter.y,blockCenter.z}+blockPos
                    --snap the closest surfance to the point
                    if whoClosest == 0 then
                        pos.x = math.floor(currentPoint.x)+value.x
                    end
                    if whoClosest == 1 then
                        pos.y = math.floor(currentPoint.y)+value.y
                    end
                    if whoClosest == 2 then
                        pos.z = math.floor(currentPoint.z)+value.z
                    end
                    if whoClosest == 3 then
                        pos.x =  math.floor(currentPoint.x)+value.w
                    end
                    if whoClosest == 4 then
                        pos.y = math.floor(currentPoint.y)+value.t
                    end
                    if whoClosest == 5 then
                        pos.z =  math.floor(currentPoint.z)+value.h
                    end
                end
            end
        end
    end
    return pos, whoClosest
end

function updateSelectionArea(a,b)
    local pos = a*1
    local scale = b*1
    if scale.x < 0 then
        pos.x = pos.x+scale.x
        scale.x = -scale.x
    end
    if scale.y < 0 then
        pos.y = pos.y+scale.y
        scale.y = -scale.y
    end
    if scale.z < 0 then
        pos.z = pos.z+scale.z
        scale.z = -scale.z
    end
    dispSelectedPos = pos
    dispSelectedArea = scale
    model.NO_PARENT_AREA.setPos(pos*towrld)
    model.NO_PARENT_AREA.setScale(scale+vectors.of{1,1,1})
end

function selectionSwizzle()
    if areaScale.x < 0 then
        areaStart.x = areaStart.x+areaScale.x
        areaScale.x = -areaScale.x
    end
    if areaScale.y < 0 then
        areaStart.y = areaStart.y+areaScale.y
        areaScale.y = -areaScale.y
    end
    if areaScale.z < 0 then
        areaStart.z = areaStart.z+areaScale.z
        areaScale.z = -areaScale.z
    end
end