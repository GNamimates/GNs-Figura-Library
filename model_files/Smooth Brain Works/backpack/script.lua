pos = nil
_pos = nil
velocity = nil

swing = {
    towel={
        pos=0,
        vel =0
    }
}

function player_init()
    pos = player.getPos()
    _pos = pos
    velocity = vectors.of({0})
end

function tick()
    _pos = pos
    pos = player.getPos()
    velocity = pos - _pos
    swing = math.deg(math.min(math.max(velocity.y*3,-90),0))
end

swing = 0
swingLanternVel = {0,0}

lastHeadRot = model.BODY.backpack.hangers.MIMIC_HEAD_lightHang.getRot()

function world_render()
    
    vel = lastHeadRot-model.BODY.backpack.hangers.MIMIC_HEAD_lightHang.getRot()
    --display
    model.BODY.backpack.towel.hang.setRot({swing,0,0})
    model.BODY.backpack.hangers.MIMIC_HEAD_lightHang.swing.setRot({0,vel.x,vel.y})
    lastHeadRot = model.BODY.backpack.hangers.MIMIC_HEAD_lightHang.getRot()
end

function dotp(value)
    if value == 0 then
        return 0
    else
        return value/math.abs(value)
    end
end