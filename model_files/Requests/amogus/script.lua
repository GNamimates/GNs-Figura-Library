timer = 0

function tick()
    if timer == 10 then
        timer = 11
        sound.playCustomSound("amogus",player.getPos(),{1,0.5})
    else
        timer = timer + 1
    end
end