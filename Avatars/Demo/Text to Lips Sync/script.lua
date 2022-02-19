lastMessage = ""
currentMessage = ""
local delay = 10

talkSpeed = 2

--group1 = {"F","V"}
----group2 = not used cuz its everything else
--group3 = {"U","R","W","Q"}
--group4 = {"O","H"}
--group5 =  {"L","TH","D"}
--group6 = {"S","N","C","K","Z","J","Y"}
--group6double = {"SH","CH","EE","CI","CE"}
--groudp7 = {"A","I","E"}
--group8 = {}

table = {
    single= {
        lipBite = {0,"F","V"},
        smile = {1},
        wowed = {2,"U","R","W","Q","O"},
        barelyOpen = {3,"H"},
        toungTeeth = {4,"N","V"},
        toungbite = {7,"L","N","T"},
        grin = {5,"S","C","K","Z","J","Y","D"},
        wideOpen = {6,"A","I","E"},
        mouthSqueeze = {8,"M"}

    },
    double = {
        lipbite = {0,},
        smile = {1,},
        wowed = {2,"OO"},
        barelyOpen =  {3,},
        toungTeeth = {4,},
        toungBite = {7,"TH"},
        grin = {5,"SH","CH","EE","CI","CE","NG"},
        wideOpen = {6,},
        mouthSqueeze = {8,}
    }
}

network.registerPing("setMouth")
chat.setFiguraCommandPrefix("")

justSentMessage = false

function onCommand(cmd)
    if not justSentMessage then
        currentMessage = cmd
        chat.setFiguraCommandPrefix("ERUFWNCOSEIWNCPK")
        chat.sendMessage(cmd)
        chat.setFiguraCommandPrefix("")
        justSentMessage = true
        
    end
    
end

function tick()
    justSentMessage = false
    if client.isHost() then
        if delay < 0 then
            if string.len(currentMessage) > 0 then
                alreadyFound = false
                --doubles
                local index = 0
                for _, group in pairs(table.double) do
                    if not alreadyFound then
                        for i, value in pairs(group) do
                            if i ~= 1 then
                                if value == string.upper(string.sub(currentMessage,1,2)) then
                                    delay = talkSpeed
                                    network.ping("setMouth",group[1])
                                    currentMessage = string.sub(currentMessage,3,9999)
                                    alreadyFound = true
                                    break
                                end
                            end
                        end
                        index = index + 1
                    end
                end
                --singles
                index = 0
                for _, group in pairs(table.single) do
                    if not alreadyFound then
                        for i, value in pairs(group) do
                            if i ~= 1 then
                                if value == string.upper(string.sub(currentMessage,1,1)) then
                                    delay = talkSpeed
                                    network.ping("setMouth",group[1])
                                    currentMessage = string.sub(currentMessage,2,9999)
                                    alreadyFound = true
                                    break
                                end
                            end
                        end
                        index = index + 1
                    end
                end
                
                if not alreadyFound then--if not found
                    network.ping("setMouth",1)
                    delay = talkSpeed
                    currentMessage = string.sub(currentMessage,2,9999)
                end
            else
                network.ping("setMouth",1)
                delay = talkSpeed
            end
        end
    end
    delay = delay - 1
end

function setMouth(index)
    model.HEAD.mouth.setUV({0,(1/9)*index})
end