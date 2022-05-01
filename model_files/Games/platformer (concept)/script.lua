maxBlocksCount = 12

a = keybind.newKey("left","A")
d = keybind.newKey("right","D")
w = keybind.newKey("up","W")
s = keybind.newKey("down","S")

config = {
    physics = {
        dynamic_substeps = true,--automatically raise the number of substeps depending on how fast the player is moving, and also fixes some bugs for some reason(recommended)
        substep_count = 1,--fixed number of substeps, if `dynamic_substeps` is false
    }
}

level = {
    id = 0
}
levels = {
    {
        spawnPoint = {0,0},
        blocks={
            {aabb={-1,-5,10,1},type="solid"},
            {aabb={1,-5,2,2},type="solid"},
            {aabb={1,-1,2,1},type="solid"},
            {aabb={-25,-11,50,5},type="lava"},
        },
        attributes={
            gravity = {0,0.1}
        }
    }
}

player = {
    lastPos = {0,0},
    pos = {0,0},
    vel = {0,0},
    attributes={
        walkspeed = 0.5,
        jumpheight = 1,
        hitboxSize = {-0.5,0,0.5,1},
    },
    isOnFloor = false
}

camera = {
    free = false,
    smoothness={0.5,0.2},
    offset={0,1},
    speed=0.4,
    pos = {0,0},
    lastPos = {0,0},
}

function level.load(id)
    local lvl = levels[id]
    level.id = id

    player.vel = {0,0}
    player.pos = {lvl.spawnPoint[1],lvl.spawnPoint[2]}
    player.lastPos = {lvl.spawnPoint[1],lvl.spawnPoint[2]}
    for i = 1, maxBlocksCount, 1 do
        model.HUD.world["block"..tostring(i)].setEnabled(false)
    end
    local c = 0
    for key, data in pairs(lvl.blocks) do
        c = c + 1
        local block = model.HUD.world["block"..tostring(c)]
        block.setEnabled(true)
        block.setPos({data.aabb[1]*16,-data.aabb[2]*16})
        block.setScale({data.aabb[3],data.aabb[4]})
        if data.type == "lava" then
            block.setColor{1,0.1,0}
        end
    end
end

function level.reset()
    level.load(level.id)
end

function player_init()
    level.load(1)
end

function tick()
    do
        local sclFctr = 1/client.getScaleFactor()
        model.HUD.setScale{sclFctr,sclFctr,1}
    end

    local substeps = config.physics.substep_count
    if config.physics.dynamic_substeps then
        substeps = math.ceil(vectors.of{player.lastPos[1]-player.pos[1],player.lastPos[2]-player.pos[2]}.getLength())+1
    end
    camera.lastPos = {camera.pos[1],camera.pos[2]}
    player.lastPos = {player.pos[1],player.pos[2]}
    for _ = 1, substeps, 1 do
        local scale = 1.0/substeps
        if camera.free then
            if a.isPressed() then
                camera.pos[1] = camera.pos[1] - camera.speed*scale
            end
            if d.isPressed() then
                camera.pos[1] = camera.pos[1] + camera.speed*scale
            end
            if w.isPressed() then
                camera.pos[2] = camera.pos[2] - camera.speed*scale
            end
            if s.isPressed() then
                camera.pos[2] = camera.pos[2] + camera.speed*scale
            end
        else
            camera.pos[1] = math.lerp(camera.pos[1],player.pos[1]+camera.offset[1],camera.smoothness[1]*scale)
            camera.pos[2] = math.lerp(camera.pos[2],player.pos[2]+camera.offset[2],camera.smoothness[2]*scale)
            if a.isPressed() then
                player.pos[1] = player.pos[1] + player.attributes.walkspeed*scale
                model.HUD.world.player.setScale{-1,1}
            end
            if d.isPressed() then
                model.HUD.world.player.setScale{1,1}
                player.pos[1] = player.pos[1] - player.attributes.walkspeed*scale
            end
        end
        
        player.pos[1] = player.pos[1] + player.vel[1]*scale--X
        for key, data in pairs(levels[level.id].blocks) do
            local aabb = aabbMixer(data.aabb,player.attributes.hitboxSize)
            if isColliding(player.pos,aabb) then
                player.vel[1] = 0
                if data.type == "solid" then
                    if aabb[1]+(aabb[3]*0.5) > -player.pos[1] then
                        player.pos[1] = -aabb[1]
                    else
                        player.pos[1] = -(aabb[1]+aabb[3])
                    end
                end
            end
        end
        player.vel[2] = player.vel[2] - 0.15*scale
        if w.isPressed() and player.isOnFloor then
            player.vel[2] = player.attributes.jumpheight
        end
        player.pos[2] = player.pos[2] + player.vel[2]*scale--Y
        player.isOnFloor = false

        for key, data in pairs(levels[level.id].blocks) do
            local aabb = aabbMixer(data.aabb,player.attributes.hitboxSize)
            if isColliding(player.pos,aabb) then
                if data.type == "solid" then
                    player.vel[2] = 0
                    if aabb[2]+(aabb[4]*0.5) > player.pos[2] then
                        player.pos[2] = aabb[2]-0.001
                    else
                        player.pos[2] = aabb[2]+aabb[4]
                        player.isOnFloor = true
                    end
                end
                if data.type == "lava" then
                    level.reset()
                end
            end
        end
    end
end

function aabbMixer(a,b)
    return  {
        a[1]+b[1],
        a[2]-b[4],
        a[3]+b[3]-b[1],
        a[4]+b[4],
    }
end

function isColliding(a,b)
    if b[1] < -a[1] then   
        if b[2] <= a[2] then
            if b[1]+b[3] > -a[1] then
                if b[2]+b[4] > a[2] then
                    return true
                end
            end
        end
    end
    return false
end

function world_render(delta)
    model.HUD.world.setPos{math.lerp(camera.lastPos[1],camera.pos[1],delta)*16,math.lerp(camera.lastPos[2],camera.pos[2],delta)*16}
    model.HUD.world.player.setPos{-math.lerp(player.lastPos[1],player.pos[1],delta)*16,-math.lerp(player.lastPos[2],player.pos[2],delta)*16}
end