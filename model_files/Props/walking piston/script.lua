--made by the one and only GNamimates w Limenewon <3

currentPosition = nil
lastPosition = nil
velocity = nil
distanceVelocity = vectors.of({})

animation.walk.play()
animation.rest.play()

for _, v in pairs(vanilla_model) do
    v.setEnabled(false)
end


function player_init()
    currentPosition = player.getPos()
    lastPosition = currentPosition
    velocity = vectors.of({0})
end

function tick()
    lastPosition = currentPosition
    currentPosition = player.getPos()
    velocity = currentPosition - lastPosition
    distanceVelocity = (velocity*vectors.of({1,0,1})).distanceTo(vectors.of({}))
end

function render(delta)
    model.NO_PARENT.setPos(player.getPos(delta)*vectors.of({-16,-16,16}))
    model.NO_PARENT.setRot({0,math.deg(math.atan2(velocity.z,velocity.x))+90})
    model.NO_PARENT.hop.piston.setRot({0,-math.deg(math.atan2(velocity.z,velocity.x))-90})
    animation.walk.setBlendWeight(distanceVelocity*2)
end