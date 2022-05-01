--[[--====================================================================---------
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
]]--======================================================================---------
--keys
G3 = keybind.newKey("G3","Q",true)
A3 = keybind.newKey("A3","W",true)
B3 = keybind.newKey("B3","E",true)
C4 = keybind.newKey("C3","R",true)
D4 = keybind.newKey("D3","T",true)
E4 = keybind.newKey("E3","Y",true)
F4 = keybind.newKey("F3","U",true)
G4 = keybind.newKey("G4","I",true)
A4 = keybind.newKey("A4","O",true)
B4 = keybind.newKey("B4","P",true)
C5 = keybind.newKey("C4","Z",true)
D5 = keybind.newKey("D5","X",true)
E5 = keybind.newKey("E5","C",true)
F5 = keybind.newKey("F5","V",true)

--sharp
SF3 = keybind.newKey("SF3","1",true)
SG3 = keybind.newKey("SF3","2",true)
SA3 = keybind.newKey("SF3","3",true)
SC4 = keybind.newKey("SF3","5",true)
SD4 = keybind.newKey("SF3","6",true)
SF4 = keybind.newKey("SF3","8",true)
SG4 = keybind.newKey("SF3","9",true)
SA4 = keybind.newKey("SF3","0",true)
SC5 = keybind.newKey("SF3","S",true)
SD5 = keybind.newKey("SF3","D",true)
SF5 = keybind.newKey("SF3","G",true)

enableSynth = true
octave = -1
keys = {SF3,G3,SG3,A3,SA3,B3,C4,SC4,D4,SD4,E4,F4,SF4,G4,SG4,A4,SA4,B4,C5,SC5,D5,E5,SD5,F5,SF5}
pressed = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}
timer = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
ping.violinToggle = function(data)
    pressed[data[1]] = data[2]
end

LastSoundDelta = {}
DingToggle = false
function tick()
    enableSynth = chat.isOpen()
    if chat.isOpen() then
        for key, value in pairs(keys) do
            if value.isPressed() ~= pressed[key] then
                ping.violinToggle({key,value.isPressed()})
            end
        end
    end
    if enableSynth then
        for key, _ in pairs(keys) do
            if pressed[key] then
                --network.ping("play",2^((key-13)/12))
                if timer[key] < 0 then
                    timer[key] = 20
                    DingToggle = not DingToggle
                    if DingToggle then
                        sound.playCustomSound("stringa",player.getPos(),{1,(2^((key-13+octave*13)/12))})
                    else
                        sound.playCustomSound("stringb",player.getPos(),{1,(2^((key-13+octave*13)/12))})
                    end
                end
                toggle = not toggle
                timer[key] = timer[key] - (2^((key-13)/12))
            else
                timer[key] = 0
            end
        end
    end
end