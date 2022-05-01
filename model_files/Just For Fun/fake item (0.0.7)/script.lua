time = 0

Position = vectors.of({-8,1,0})
ItemName = "minecraft:diamond_pickaxe"

model.NO_PARENT.setPos(Position*vectors.of({-16,-16,16}))

action_wheel.SLOT_1.setItem(ItemName)
action_wheel.SLOT_1.setTitle("change item")
action_wheel.SLOT_1.setFunction(function ()
    chat.setFiguraCommandPrefix("")
    log("say the item name in chat(say cancel to cancel)")
end)

action_wheel.SLOT_2.setTitle("move item to current position")
action_wheel.SLOT_2.setItem("spectral_arrow")
action_wheel.SLOT_2.setFunction(function ()
    Position = player.getPos()
    model.NO_PARENT.setPos(Position*vectors.of({-16,-16,16}))
end)

function onCommand(cmd)
    chat.setFiguraCommandPrefix("#$%^#&%#&(^%*#%^")
    
    if cmd == "cancel" then
        log("canceled")
    else
        log("item setted to: "..cmd)
        ItemName = cmd
        action_wheel.SLOT_1.setItem(ItemName)
    end
    
end

function tick()
    time = time + 1
end

function world_render(delta)
    delta = 0
    local trueTime = time+delta
    renderer.renderItem(ItemName,model.NO_PARENT,"GROUND",false,vectors.of({0,(math.sin(trueTime*0.1))-3.5,0}),vectors.of({0,trueTime*3}))
end