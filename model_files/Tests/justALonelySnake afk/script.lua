afkTime = 1 -- in seconds

idleTime = 0
isAFK = false
wasAFK = false

lastPlayerRot = vectors.of {}
function tick()
    if player.getVelocity().getLength() < 0.01 and
        (player.getRot(0) - lastPlayerRot).getLength() < 0.1 then
        idleTime = idleTime + 1
        if idleTime > afkTime * 20 then
            isAFK = true
            if isAFK ~= wasAFK then
                print("AFK")
                wasAFK = isAFK
            end
        end
    else
        idleTime = 0
        isAFK = false
        if isAFK ~= wasAFK then
            print("NOT AFK")
            wasAFK = isAFK
        end
    end
    lastPlayerRot = player.getRot()
end
