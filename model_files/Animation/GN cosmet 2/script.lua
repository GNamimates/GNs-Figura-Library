vectors.toWorld = vectors.of{-16,-16,16}

isFirstPerson = false

function tick()
    isFirstPerson = renderer.isFirstPerson()
    model.NO_PARENT.setEnabled(not isFirstPerson)
end

function world_render(delta)
    if not isFirstPerson then
        model.NO_PARENT.setPos(player.getPos(delta)*vectors.toWorld)
    end
end