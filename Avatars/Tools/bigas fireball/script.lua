shoot = keybind.getRegisteredKeybind("key.attack")

isShooting = false

speed = 0.2
power = 10

function tick()
    if shoot.isPressed() and shoot.isPressed() ~= isShooting then
        m = {
            x=player.getLookDir().x,
            y=player.getLookDir().y,
            z=player.getLookDir().z
        }
        chat.sendMessage("/summon fireball ~ ~"..player.getEyeHeight().." ~ {power:["..m.x*speed..","..m.y*speed..","..m.z*speed.."],ExplosionPower:"..power.."}")
    end
    isShooting = shoot.isPressed()
end