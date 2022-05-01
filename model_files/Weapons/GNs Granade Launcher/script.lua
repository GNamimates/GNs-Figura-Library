keyShoot = keybind.newKey("Shoot","MOUSE_BUTTON_2")
wasKeyShoot = false

cooldown = 0

function tick()
    cooldown = cooldown - 1
    if keyShoot.isPressed() and cooldown < 0 then
        local velocity = player.getLookDir()
        velocity.x = math.floor(velocity.x*100)/100
        velocity.y = math.floor(velocity.y*100)/100
        velocity.z = math.floor(velocity.z*100)/100
        if not tostring(velocity.x):find(".") then
            velocity.x = tostring(velocity.x)..".0"
        else
            velocity.x = tostring(velocity.x)
        end
        if not tostring(velocity.y):find(".") then
            velocity.y = tostring(velocity.y)..".0"
        else
            velocity.y = tostring(velocity.y)
        end
        if not tostring(velocity.z):find(".") then
            velocity.z = tostring(velocity.z)..".0"
        else
            velocity.z = tostring(velocity.z)
            chat.sendMessage("/summon tnt "..player.getPos().x.." "..player.getPos().y+player.getEyeHeight().." "..player.getPos().z.." {Time:1,Motion:["..velocity.x..", "..velocity.y..", "..velocity.z.."],Fuse:10}")
        end
        cooldown = 1
    end
end