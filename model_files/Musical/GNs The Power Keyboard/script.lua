
--keys
G3 = keybind.newKey("G3","Q")
A3 = keybind.newKey("A3","W")
B3 = keybind.newKey("B3","E")
C4 = keybind.newKey("C3","R")
D4 = keybind.newKey("D3","T")
E4 = keybind.newKey("E3","Y")
F4 = keybind.newKey("F3","U")
G4 = keybind.newKey("G4","I")
A4 = keybind.newKey("A4","O")
B4 = keybind.newKey("B4","P")
C5 = keybind.newKey("C4","Z")
D5 = keybind.newKey("D5","X")
E5 = keybind.newKey("E5","C")
F5 = keybind.newKey("F5","V")

--sharp
SF3 = keybind.newKey("SF3","1")
SG3 = keybind.newKey("SF3","2")
SA3 = keybind.newKey("SF3","3")
SC4 = keybind.newKey("SF3","5")
SD4 = keybind.newKey("SF3","6")
SF4 = keybind.newKey("SF3","8")
SG4 = keybind.newKey("SF3","9")
SA4 = keybind.newKey("SF3","0")
SC5 = keybind.newKey("SF3","S")
SD5 = keybind.newKey("SF3","D")
SF5 = keybind.newKey("SF3","G")


--list
notePaths = {
    
}

keys = {SF3,G3,SG3,A3,SA3,B3,C4,SC4,D4,SD4,E4,F4,SF4,G4,SG4,A4,SA4,B4,C5,SC5,D5,E5,SD5,F5,SF5}
sharp = {true,false,true,false,true,false,false,true,false,true,false,false,true,false,true,false,true,false,false,true,false,false,true,false,true}

keyModelPaths = {
    model.NO_PARENT.paino.SF3,
    model.NO_PARENT.paino.G3,
    model.NO_PARENT.paino.SG3,
    model.NO_PARENT.paino.A3,
    model.NO_PARENT.paino.SA3,
    model.NO_PARENT.paino.B3,
    model.NO_PARENT.paino.C4,
    model.NO_PARENT.paino.SC4,
    model.NO_PARENT.paino.D4,
    model.NO_PARENT.paino.SD4,
    model.NO_PARENT.paino.E4,
    model.NO_PARENT.paino.F4,
    model.NO_PARENT.paino.SF4,
    model.NO_PARENT.paino.G4,
    model.NO_PARENT.paino.SG4,
    model.NO_PARENT.paino.A4,
    model.NO_PARENT.paino.SA4,
    model.NO_PARENT.paino.B4,
    model.NO_PARENT.paino.C5,
    model.NO_PARENT.paino.SC5,
    model.NO_PARENT.paino.D5,
    model.NO_PARENT.paino.E5,
    model.NO_PARENT.paino.SD5,
    model.NO_PARENT.paino.F5,
    model.NO_PARENT.paino.SF5}

pressed = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}
--hand stuff ahah
toggle = false

keyboardMode = false
storedKeys = {}

defaultSound = "block.note_block.harp"
currentSound = defaultSound

chat.setFiguraCommandPrefix("/note")
network.registerPing("play")
network.registerPing("changeSound")

--TRACKS
track1 = "2,34,6561,2,343,5654,444,6654,666,5654,444,6654,666,888"
--"4 44434 434  565 4 44434 41" titanic die
--"1242665 1242554 124245321154 1242665 124283432 124245321154" never gonna give you up
track1Tempo = 2

action_wheel.SLOT_1.setItem(item_stack.createItem("minecraft:music_disc_cat"))
action_wheel.SLOT_1.setFunction(function ()
    queue = tostring(track1)
end)

queue = ""
queueWait = 0
offset = 7

pos = nil
_pos = nil
velocity = nil

function player_init()
    pos = player.getPos()
    _pos = pos
    velocity = vectors.of({0})
end

function tick()
    _pos = pos
    pos = player.getPos()
    velocity = pos - _pos
    if queueWait <= 0 then
        if string.len(queue) > 0 then
            if string.sub(queue,1,1) == "," then
                queue = string.sub(queue,2,99999)
                queueWait = 16
            else
                note = (tonumber(string.sub(queue,1,1))+offset)
                if sharp[note+1]then
                    note = note +1
                end
                network.ping("play",2^((note-13)/12))
                queue = string.sub(queue,2,99999)
                queueWait = 8
            end
            
        end
    end
    queueWait = queueWait - 1
end


function world_render(delta)
    model.NO_PARENT.setPos(((player.getPos())+vectors.of({0,1.2,0}))*vectors.of({-16,-16,16}))
    model.NO_PARENT.setRot({0,-player.getBodyYaw()+180})
    --useless comment

    vanilla_model.RIGHT_ARM.setRot({0,0,0})
    vanilla_model.RIGHT_SLEEVE.setRot({0,0,0})
    vanilla_model.LEFT_ARM.setRot({0,0,0})
    vanilla_model.LEFT_SLEEVE.setRot({0,0,0})

    for key, value in pairs(keys) do
        if value.isPressed() then
            if not pressed[key] then
                network.ping("play",2^((key-13)/12))
                toggle = not toggle
            end
        end
        pressed[key] = value.isPressed()
        if value.isPressed() then
            keyModelPaths[key].setPos({0,0.19,0})
            if toggle then
                vanilla_model.RIGHT_ARM.setRot({-120,0,0})
                vanilla_model.RIGHT_SLEEVE.setRot({-120,0,0})
            else
                vanilla_model.LEFT_ARM.setRot({-120,0,0})
                vanilla_model.LEFT_SLEEVE.setRot({-120,0,0})
            end
        else
            keyModelPaths[key].setPos({0,0,0})
        end
    end
end

function changeSound(path)
    currentSound = path
end

function play(pitch)
    sound.playSound(currentSound,player.getPos(),{1,pitch})
end

function onCommand(cmd)
    local path = string.sub(cmd,7,9999999)
    if path == "reset" then
        network.ping("changeSound",defaultSound)
        log("reseted sound back to default")
    else
        log("changed keyboard sounds to: "..path)
        network.ping("changeSound",path)
    end
end

--CORPSES

--function savekeybinds()
--    for key, value in pairs(keybind.getRegisteredKeyList()) do
--        storedKeys[key] = tostring(keybind.getRegisteredKeybind(value).getKey())
--    end
--    logTableContent(storedKeys)
--end
--
--function loadkeybinds()
--    for key, value in pairs(keybind.getRegisteredKeyList()) do
--        keybind.getRegisteredKeybind("key.hotbar.1").setKey("Y")
--    end
--end