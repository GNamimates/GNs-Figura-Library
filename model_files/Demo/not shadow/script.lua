
SHADOW_ROTATION = vectors.of({0,0,0})

animation.flatten.play()


function tick()
    SHADOW_ROTATION = vectors.of({0,0,(world.getTimeOfDay()/12000)*90})
end

function world_render(delta)
    model.flattening.setEnabled(not renderer.isFirstPerson())
    model.flattening.setScale({1,10000000000,1})
    if not renderer.isFirstPerson() then
        model.flattening.setRot({0,player.getBodyYaw(delta),0})
        model.flattening.offset.MIMIC_BODY.setRot({0,-player.getBodyYaw(delta),0})
        model.flattening.offset.setRot(SHADOW_ROTATION)
        local ray = renderer.raycastBlocks(player.getPos(delta) + vectors.of({0,1,0}),player.getPos(delta) + vectors.of({0,-50,0}), "COLLIDER", "NONE")
        if ray then
            model.flattening.offset.MIMIC_BODY.setPos({0,(ray.pos.y-player.getPos(delta).y)*16 - 0.1})
            model.flattening.offset.MIMIC_HEAD.setPos({0,(ray.pos.y-player.getPos(delta).y)*16 - 0.1})
            model.flattening.setPos({0,(ray.pos.y-player.getPos(delta).y)*-16 - 0.3})
            if player.isSneaky() then
                model.flattening.setPos(model.flattening.getPos()-vectors.of({0,2,0}))
            end
        end
    end
    
end