length = 4

pos = {vectors.of({}),vectors.of({}),vectors.of({}),vectors.of({})}
lastPos = pos

lastMessage = ""

maxAppleDistance = 3

applePos = vectors.of({})

function move(vec)
    lastPos = pos
    pos[1] = pos[1] + vec
    for i = length, 1, -1 do
        pos[1+i] = pos[i]
    end
    if pos[1].distanceTo(applePos) < 0.5 then
        local startP = vectors.of({math.floor(player.getPos().x),math.floor(player.getPos().y),math.floor(player.getPos().z)})
        network.ping("newApplePos",startP + vectors.of({math.floor(lerp(-maxAppleDistance,maxAppleDistance,math.random())),math.floor(lerp(-maxAppleDistance,maxAppleDistance,math.random())),math.floor(lerp(-maxAppleDistance,maxAppleDistance,math.random()))}))
        add()
    end
end

function add()
    pos[length] = pos[1]
    length = length + 1
end




network.registerPing("newApplePos")


function newApplePos(pos)
    applePos = pos
    model.NO_PARENT_APPLE.setPos(pos*vectors.of({-16,-16,16}))
end


function player_init()
    local startP = vectors.of({math.floor(player.getPos().x),math.floor(player.getPos().y),math.floor(player.getPos().z)})
    pos = {startP,startP,startP,startP}
    lastPos = pos
    network.ping("newApplePos",startP + vectors.of({math.floor(lerp(-maxAppleDistance,maxAppleDistance,math.random())),math.floor(lerp(-maxAppleDistance,maxAppleDistance,math.random())),math.floor(lerp(-maxAppleDistance,maxAppleDistance,math.random()))}))
end

function lerp(a, b, x)
    return a + (b - a) * x
end


function tick()
    if chat.getMessage(1) then
        if chat.getMessage(1) ~= lastMessage then
            lastMessage = chat.getMessage(1)
            if string.find(chat.getMessage(1),"up") then
                move(vectors.of{0,1,0})
                return
            end
            if string.find(chat.getMessage(1),"down") then
                move(vectors.of{0,-1,0})
                return
            end
            if string.find(chat.getMessage(1),"left") then
                move(vectors.of{-1,0,0})
                return
            end
            if string.find(chat.getMessage(1),"right") then
                move(vectors.of{1,0,0})
                return
            end
            if string.find(chat.getMessage(1),"front") then
                move(vectors.of{0,0,1})
                return
            end
            if string.find(chat.getMessage(1),"back") then
                move(vectors.of{0,0,-1})
                return
            end
        end
    end
    for i = length, 1, -1 do
        model["NO_PARENT_SNAKE"..i].setPos(vectors.lerp(pos[i],model["NO_PARENT_SNAKE"..i].getPos()/vectors.of({-16,-16,16}),0.4)*vectors.of({-16,-16,16}))
    end
end