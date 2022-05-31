vectors.worldPos = vectors.of{-16,-16,16}
vectors.worldRot = vectors.of{-1,-1,1}

vanilla_model.LEFT_ARM.setEnabled(false)
vanilla_model.LEFT_SLEEVE.setEnabled(false)
vanilla_model.RIGHT_ARM.setEnabled(false)
vanilla_model.RIGHT_SLEEVE.setEnabled(false)

model.NO_PARENT.leftArm.Ldef.setTexture("Skin")
model.NO_PARENT.leftArm.Lslim.setTexture("Skin")
model.NO_PARENT.rightArm.Rdef.setTexture("Skin")
model.NO_PARENT.rightArm.Rslim.setTexture("Skin")
model.NO_PARENT.leftArm.setExtraTexEnabled(false)
model.NO_PARENT.rightArm.Rdef.setExtraTexEnabled(false)
model.NO_PARENT.rightArm.Rslim.setExtraTexEnabled(false)
--model.NO_PARENT.rightArm.minigun.setTexture("Custom")

animation.idleIntro.setSpeed(2)
animation.scopeIntro.setSpeed(2)

animation.idleIntro.play()

scopeKey = keybind.newKey("Aim","MOUSE_BUTTON_2")
shootKey = keybind.newKey("Shoot","MOUSE_BUTTON_1")

water = {}
spread = 0.02

wasScoping = false
isScoping = false
function player_init()
    local slim = player.getModelType() == "slim"
    model.NO_PARENT.leftArm.Ldef.setEnabled(not slim)
    model.NO_PARENT.leftArm.Lslim.setEnabled(slim)
    model.NO_PARENT.rightArm.Rdef.setEnabled(not slim)
    model.NO_PARENT.rightArm.Rslim.setEnabled(slim)
end

function tick()
    isScoping = scopeKey.isPressed()
    if isScoping ~= wasScoping then
        if isScoping then
            animation.idleIntro.stop()
            animation.scopeIntro.play()
        else
            animation.idleIntro.play()
            animation.scopeIntro.stop()
        end
    end
    if shootKey.isPressed() then
        for i = 1, 10, 1 do
            table.insert(water, {
                pos=(player.getPos()+vectors.of{0,player.getEyeHeight()}),
                vel=player.getLookDir()*0.5+vectors.of{math.lerp(-spread,spread,math.random()),math.lerp(-spread,spread,math.random()),math.lerp(-spread,spread,math.random())},
                age = 40
            })
        end
    end
    wasScoping = isScoping

    for key, p in pairs(water) do
        p.pos = p.pos + p.vel
        p.vel = p.vel + vectors.of{0,-0.01,0}
        p.age = p.age - 1
        if p.age <= 0 then
            table.remove(water, key)
        end
        
        local ray = renderer.raycastEntities(p.pos, p.pos + vectors.of{0,-1,0})
        if ray then
            
            chat.sendMessage("/data merge entity "..tostring(ray.entity.getUUID()).." {Motion:["..crap(p.vel.x)..","..crap(p.vel.y)..","..crap(p.vel.z).."]} ")
        end

        particle.addParticle("minecraft:dust",{p.pos.x,p.pos.y,p.pos.z,p.vel.x,p.vel.y,p.vel.z},{0.333, 0.529, 0.85,1})

        if world.getBlockState(p.pos).isCollidable() then
            water[key] = nil
        end
    end
end

function world_render(delta)
    model.NO_PARENT.setPos((player.getPos(delta)+vectors.of{0,player.getEyeHeight()}) * vectors.worldPos)
    model.NO_PARENT.setRot(player.getRot(delta)*vectors.worldRot + vectors.of{0,180,0})
end

function crap(x)
    x = math.floor(x*10)/10
    if x == math.floor(x) then
        x = tostring(x)..".0"
    end
    return tostring(x)
end