--[[--====================================================================---------
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
--=================================================================================--]]

earTwitchChangePersentage = 0.001

for _, p in pairs(vanilla_model) do
    p.setEnabled(false)
end

lastLocalVel = nil
vel = nil
localVel = vectors.of{}
localMom = 0

lastBodyRot = 0
bodyRot = 0

lastHeadRot = nil
headRot = nil


tail = {
    lx = 0,
    ly = 0,
    x = 0,
    y = 0,
    vx = 0,
    vy = 0,
    damp = 0.8,
}

ear = {
    lx = 0,
    ly = 0,
    x = 0,
    y = 0,
    vx = 0,
    vy = 0,
    damp = 0.75,
}

function player_init()
    lastBodyRot = player.getBodyYaw()
    lastHeadRot = player.getRot()
end

function tick()
    bodyRot = player.getBodyYaw()
    headRot = player.getRot()

    tail.lx = tail.x
    tail.ly = tail.y

    ear.lx = ear.x
    ear.ly = ear.y
    vel = player.getVelocity()
    lastLocalVel = localVel*1
    localVel = vectors.of{
        (math.sin(math.rad(-player.getRot().y))*vel.x)+(math.cos(math.rad(-player.getRot().y))*vel.z),
        vel.y,
        (math.sin(math.rad(-player.getRot().y+90))*vel.x)+(math.cos(math.rad(-player.getRot().y+90))*vel.z)
    }
    localMom = localVel-lastLocalVel
    tail.vy = tail.vy + localMom.y * 1.5--momentum
    tail.vx = tail.vx + localMom.x + (bodyRot-lastBodyRot) * 0.01
    tail.x = math.clamp(tail.x + tail.vx,-2,2)--velocity
    tail.y = math.max(tail.y + tail.vy,-0.5)
    tail.vx = tail.vx * tail.damp + (tail.x*-0.1)
    tail.vy = tail.vy * tail.damp + (tail.y*-0.1)

    ear.vy = ear.vy + localMom.y * 1.5 + (headRot.x-lastHeadRot.x) * 0.01--momentum
    ear.vx = ear.vx + localMom.x + (headRot.y-lastHeadRot.y) * 0.01
    ear.x = ear.x + ear.vx--velocity
    ear.y = ear.y + ear.vy
    ear.vx = ear.vx * ear.damp + (ear.x*-0.1)
    ear.vy = ear.vy * ear.damp + (ear.y*-0.1)
    
    lastBodyRot = bodyRot * 1
    lastHeadRot = headRot * 1

    if chance(earTwitchChangePersentage) then
        animation.LT.play()
    end
    if chance(earTwitchChangePersentage) then
        animation.RT.play()
    end
end

function world_render(delta)
    model.Body.tail.setRot{math.lerp(tail.ly,tail.y,delta)*45,math.lerp(tail.lx,tail.x,delta)*45}
    model.Head.Lear.setRot{math.lerp(ear.ly,ear.y,delta)*45,math.lerp(ear.lx,ear.x,delta)*45}
    model.Head.Rear.setRot{math.lerp(ear.ly,ear.y,delta)*45,math.lerp(ear.lx,ear.x,delta)*45}
end

function chance(percent)
    return math.random() < percent
end