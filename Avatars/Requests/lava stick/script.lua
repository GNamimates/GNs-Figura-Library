shoot = keybind.getRegisteredKeybind("key.attack")
isShooting = false

function tick()
    if isShooting ~= shoot.isPressed() then
        if shoot.isPressed() then
            chat.sendMessage("/summon fireball ~ ~1.5 ~ {Motion:["..player.getLookDir().x..","..player.getLookDir().y.." ,"..player.getLookDir().z.."]}")
        end
    end
    isShooting = shoot.isPressed()
end