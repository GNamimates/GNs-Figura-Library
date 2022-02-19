
function player_init()
    lastpos = vectors.of({0})
end

function tick()
    velocity = player.getPos()-lastpos
    PI = 3.14159

    rot = player.getRot().y
    localVelocity = {}
    localVelocity.z = math.sin(math.rad(-rot))*velocity.x
    localVelocity.z = localVelocity.z+math.cos(math.rad(-rot))*velocity.z

    localVelocity.x = math.cos(math.rad(rot))*velocity.x
    localVelocity.x = localVelocity.x+math.sin(math.rad(rot))*velocity.z

    model.body.bone1.bone2.bone3.bone4.bone5.bone6.bone7.setRot(model.body.bone1.bone2.bone3.bone4.bone5.bone6.getRot())
    model.body.bone1.bone2.bone3.bone4.bone5.bone6.setRot(model.body.bone1.bone2.bone3.bone4.bone5.getRot())
    model.body.bone1.bone2.bone3.bone4.bone5.setRot(model.body.bone1.bone2.bone3.bone4.getRot())
    model.body.bone1.bone2.bone3.bone4.setRot(model.body.bone1.bone2.bone3.getRot())
    model.body.bone1.bone2.bone3.setRot(model.body.bone1.bone2.getRot())
    model.body.bone1.bone2.setRot(model.body.bone1.getRot())
    model.body.bone1.setRot(model.body.getRot())
    if player.isWet() then
        model.body.setRot({-2,0,(localVelocity.x*50.0)})
    else
         model.body.setRot({(math.max(math.min(localVelocity.z*2,PI/4)+(-velocity.y*1),0)*-30),0,(localVelocity.x*50.0)})
    end
    lastpos = player.getPos()
end