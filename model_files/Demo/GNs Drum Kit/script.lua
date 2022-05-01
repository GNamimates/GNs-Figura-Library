


UISCALE = 1
--===================================--
click = keybind.newKey("LC","MOUSE_BUTTON_1",true)
wasPressed = click.isPressed()


wasChatOpen = false

data = {
    A={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    B={0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    C={1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0},
    D={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    E={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    F={0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0},
    G={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    H={1,0,0,0,0,0,0,1,1,0,1,0,0,0,1,0},
}

rowColors = {{255/255, 8/2555, 85/255},{255/255, 170/255, 0/255},{255/255, 255/255, 85/255},{0/255, 170/255, 0/255},{85/255, 255/255, 85/255},{85/255, 255/255, 255/255},{85/255, 85/255, 255/255},{255/255, 85/255, 255/255}}
letter = {"A","B","C","D","E","F","G","H"}
instruments = {"CrashCymbal","openHiHat","closedHiHat","clap","midTom","snare","floorTom","kick"}

last_placed = vectors.of({0,0})
selection_mode = false
isInsideDrumkit = false

playing = false
time = 0
speed = 0.6
offsetTime = client.getSystemTime()*speed*0.01
lastBeat = 0

network.registerPing("playSound")

model.HUD.setScale({UISCALE*1,UISCALE*1,1})


function player_init()
    updateHUD(chat.isOpen())
    for Yi, Y in pairs(data) do
        local indeY = letter2number(Yi)
        local indeX = 0
        for Xi, value in pairs(Y) do
            indeX = indeX + 1
            model.HUD[Yi][Yi.."_slot"..Xi][Yi.."_button"..Xi].setColor(rowColors[indeY])
        end
    end
end

function world_render() 
    if client.isHost() then
        if playing then
            time = ((client.getSystemTime()*speed*0.01)-offsetTime)%16
            if time < speed + time then
                if math.floor(time) ~= lastBeat then
                    for index, instr in pairs(instruments) do
                        if data[letter[index]][math.floor(time+1)] == 1 then
                            network.ping("playSound",{instr=instr,pos=player.getPos(),volpitch={1,1}})
                        end
                    end
                end
                lastBeat = math.floor(time)
            end
        end
        if chat.isOpen() ~= wasChatOpen then
            updateHUD(chat.isOpen())
        end
        wasChatOpen = chat.isOpen()
    
        if chat.isOpen() then
            isInsideDrumkit = false
            for Yi, Y in pairs(data) do
                local indeY = letter2number(Yi)
                local indeX = 0
                for Xi, value in pairs(Y) do
                    indeX = indeX + 1
                    if isMouseInsideRect(vectors.of({(indeX-1)*20,(indeY-1)*20,(indeX)*20,(indeY)*20})) then
                        isInsideDrumkit = true
                        
                        if click.isPressed() and isInsideDrumkit then
                            data[Yi][indeX] = selection_mode
                            if selection_mode == 1 then
                                
                                if last_placed.x~= indeX and last_placed.y ~= indeY then
                                    sound.playCustomSound(instruments[indeY],player.getPos(),{1,1})
                                    last_placed = {x=indeX,y=indeY}
                                end
                            else
                                last_placed = {x=-1,y=-1} 
                            end
                        else
                            selection_mode = (value*-1)+1
                        end
                        --model.HUD[Yi][Yi.."_slot"..Xi].setColor({0,1,0})
                    else
                        --model.HUD[Yi][Yi.."_slot"..Xi].setColor({1,0,0})
                        --model.HUD.A.A_slot1
                    end
                    model.HUD[Yi][Yi.."_slot"..Xi][Yi.."_button"..Xi].setEnabled(number2Bool(value))
                    --model.HUD.E.E_slot5.E_button5.
                    if indeX == math.floor(time)+1 then
                        model.HUD[Yi][Yi.."_slot"..Xi].setScale({1.1,1.1,1.1})
                    else
                        model.HUD[Yi][Yi.."_slot"..Xi].setScale({1,1,1})
                    end
                end
            end
        end
    end
end

function tick()
    if client.isHost() then
        model.HUD.setPos(client.getWindowSize()/vectors.of({-5,-5})/client.getScaleFactor())
        if isMouseInsideRect(vectors.of({320,0,320+40,20})) then
            if wasPressed ~= click.isPressed() and click.isPressed() then
                playing = not playing
                model.HUD.playback.play.setEnabled(playing)
                model.HUD.playback.stop.setEnabled(not playing)
                offsetTime = client.getSystemTime()*speed*0.01
            end
        end
        wasPressed = click.isPressed()

    end
end

function updateHUD(isOpen)
    model.HUD.setEnabled(isOpen)
    --sound.playCustomSound("kick",player.getPos(),{1,1})
end

function isMouseInsideRect(rect2D)
    local mousePos = (client.getMousePos()/UISCALE)/client.getScaleFactor()
    local isInside = false
    if rect2D.x < mousePos.x and rect2D.z >= mousePos.x then
        if rect2D.y < mousePos.y and rect2D.w >= mousePos.y then
            isInside = true
        end
    end
    return isInside
end

function letter2number(letr)
    local letter = {"A","B","C","D","E","F","G","H"}
    for index, character in pairs(letter) do
        if letr == character then
            return index
        end
    end
end

function number2Bool(number)
    if number ~= 0 then
        return true
    else
        return false
    end
end

function playSound(data)
    sound.playCustomSound(data.instr,data.pos,data.volpitch)
end