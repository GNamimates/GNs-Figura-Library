model.SKULL.setPos{-8,0,7.99}
model.SKULL.setScale{8,8,1}

--============ CREDITS ===================--
--creator: GNamimates

--== network testers ==--
--Jepril and Lumelia_ 


--====================CLIENT STUFF===========================
SCREEN_RESOLUTION = vectors.of{20,12}
PIXELS_COUNT = SCREEN_RESOLUTION.x*SCREEN_RESOLUTION.y

rawData = {}
compressedData = ""
ClientCompressedData = ""
clientData = {}

presets = {moanalisa={{1,1,1},{0.505882,0.482353,0.454902},{0.356863,0.329412,0.294118},{0.337255,0.301961,0.262745},{0.321569,0.278431,0.227451},{0.235294,0.192157,0.145098},{0.156863,0.101961,0.05098},{0.160784,0.105882,0.054902},{0.164706,0.113725,0.062745},{0.172549,0.121569,0.070588},{0.180392,0.12549,0.078431},{0.176471,0.129412,0.082353},{0.160784,0.121569,0.078431},{0.164706,0.129412,0.086275},{0.184314,0.145098,0.098039},{0.211765,0.164706,0.117647},{0.219608,0.172549,0.12549},{0.635294,0.615686,0.596078},{1,1,1},{1,1,1},{1,1,1},{0.419608,0.388235,0.356863},{0.262745,0.231373,0.192157},{0.278431,0.235294,0.192157},{0.282353,0.239216,0.192157},{0.243137,0.196078,0.141176},{0.152941,0.098039,0.047059},{0.152941,0.098039,0.047059},{0.152941,0.098039,0.047059},{0.152941,0.098039,0.047059},{0.160784,0.109804,0.054902},{0.164706,0.113725,0.054902},{0.176471,0.121569,0.062745},{0.176471,0.121569,0.062745},{0.168627,0.113725,0.058824},{0.152941,0.101961,0.047059},{0.152941,0.101961,0.05098},{0.615686,0.596078,0.572549},{1,1,1},{1,1,1},{1,1,1},{0.427451,0.4,0.368627},{0.262745,0.227451,0.192157},{0.27451,0.235294,0.196078},{0.270588,0.231373,0.188235},{0.25098,0.196078,0.141176},{0.152941,0.098039,0.047059},{0.219608,0.152941,0.098039},{0.223529,0.156863,0.101961},{0.231373,0.160784,0.105882},{0.247059,0.184314,0.121569},{0.258824,0.192157,0.129412},{0.282353,0.203922,0.137255},{0.286275,0.203922,0.141176},{0.270588,0.192157,0.129412},{0.239216,0.160784,0.101961},{0.164706,0.113725,0.058824},{0.635294,0.615686,0.592157},{1,1,1},{1,1,1},{1,1,1},{0.443137,0.411765,0.380392},{0.262745,0.227451,0.192157},{0.27451,0.235294,0.196078},{0.254902,0.219608,0.184314},{0.223529,0.180392,0.137255},{0.156863,0.098039,0.047059},{0.607843,0.466667,0.392157},{0.623529,0.47451,0.403922},{0.635294,0.482353,0.419608},{0.654902,0.505882,0.454902},{0.65098,0.501961,0.45098},{0.635294,0.482353,0.423529},{0.635294,0.482353,0.423529},{0.607843,0.443137,0.376471},{0.560784,0.380392,0.298039},{0.203922,0.145098,0.082353},{0.654902,0.639216,0.611765},{1,1,1},{1,1,1},{1,1,1},{0.45098,0.423529,0.392157},{0.282353,0.239216,0.2},{0.270588,0.235294,0.192157},{0.266667,0.227451,0.188235},{0.321569,0.258824,0.207843},{0.4,0.294118,0.243137},{0.607843,0.458824,0.4},{0.603922,0.454902,0.396078},{0.596078,0.447059,0.392157},{0.603922,0.454902,0.403922},{0.588235,0.443137,0.392157},{0.560784,0.419608,0.364706},{0.615686,0.466667,0.4},{0.592157,0.431373,0.360784},{0.537255,0.360784,0.278431},{0.45098,0.301961,0.227451},{0.780392,0.72549,0.694118},{1,1,1},{1,1,1},{1,1,1},{0.462745,0.439216,0.407843},{0.27451,0.235294,0.196078},{0.282353,0.243137,0.2},{0.364706,0.290196,0.231373},{0.396078,0.313726,0.262745},{0.572549,0.431373,0.384314},{0.623529,0.486275,0.443137},{0.596078,0.458824,0.431373},{0.537255,0.4,0.392157},{0.576471,0.423529,0.380392},{0.568627,0.419608,0.368627},{0.54902,0.411765,0.34902},{0.541176,0.407843,0.415686},{0.564706,0.435294,0.439216},{0.623529,0.505882,0.466667},{0.545098,0.380392,0.309804},{0.827451,0.768627,0.741176},{1,1,1},{1,1,1},{1,1,1},{0.470588,0.45098,0.419608},{0.262745,0.231373,0.192157},{0.329412,0.266667,0.219608},{0.792157,0.556863,0.423529},{0.45098,0.34902,0.286275},{0.603922,0.454902,0.4},{0.85098,0.862745,0.921569},{0.627451,0.611765,0.768627},{0.278431,0.207843,0.505882},{0.564706,0.392157,0.392157},{0.615686,0.439216,0.384314},{0.623529,0.470588,0.403922},{0.32549,0.243137,0.490196},{0.501961,0.470588,0.67451},{0.858824,0.878431,0.941176},{0.576471,0.439216,0.396078},{0.847059,0.796078,0.780392},{1,1,1},{1,1,1},{1,1,1},{0.482353,0.462745,0.431373},{0.262745,0.227451,0.192157},{0.337255,0.270588,0.219608},{0.772549,0.537255,0.396078},{0.572549,0.415686,0.313726},{0.560784,0.392157,0.321569},{0.690196,0.611765,0.611765},{0.611765,0.509804,0.54902},{0.498039,0.364706,0.454902},{0.447059,0.298039,0.27451},{0.431373,0.286275,0.239216},{0.423529,0.286275,0.239216},{0.541176,0.392157,0.396078},{0.572549,0.427451,0.407843},{0.572549,0.435294,0.376471},{0.454902,0.305882,0.227451},{0.811765,0.764706,0.737255},{1,1,1},{1,1,1},{1,1,1},{0.501961,0.47451,0.447059},{0.313726,0.262745,0.215686},{0.537255,0.415686,0.333333},{0.764706,0.533333,0.392157},{0.662745,0.462745,0.337255},{0.517647,0.341176,0.25098},{0.568627,0.419608,0.368627},{0.580392,0.423529,0.380392},{0.588235,0.419608,0.392157},{0.392157,0.25098,0.211765},{0.368627,0.223529,0.188235},{0.364706,0.223529,0.184314},{0.537255,0.368627,0.313726},{0.533333,0.364706,0.298039},{0.501961,0.337255,0.254902},{0.439216,0.286275,0.207843},{0.819608,0.772549,0.74902},{1,1,1},{1,1,1},{1,1,1},{0.705882,0.603922,0.533333},{0.513726,0.388235,0.301961},{0.733333,0.552941,0.439216},{0.756863,0.529412,0.392157},{0.592157,0.396078,0.294118},{0.494118,0.317647,0.227451},{0.505882,0.32549,0.239216},{0.462745,0.286275,0.219608},{0.4,0.231373,0.196078},{0.4,0.231373,0.196078},{0.4,0.231373,0.196078},{0.4,0.231373,0.196078},{0.4,0.231373,0.2},{0.431373,0.266667,0.207843},{0.470588,0.309804,0.215686},{0.435294,0.286275,0.203922},{0.764706,0.756863,0.733333},{0.980392,0.992157,0.992157},{1,1,1},{0.847059,0.956863,0.956863},{0.701961,0.760784,0.717647},{0.623529,0.580392,0.478431},{0.741176,0.560784,0.427451},{0.741176,0.529412,0.4},{0.564706,0.384314,0.282353},{0.431373,0.278431,0.192157},{0.427451,0.27451,0.192157},{0.419608,0.266667,0.192157},{0.411765,0.262745,0.192157},{0.411765,0.266667,0.196078},{0.411765,0.266667,0.196078},{0.411765,0.270588,0.196078},{0.431373,0.278431,0.203922},{0.435294,0.286275,0.203922},{0.435294,0.286275,0.203922},{0.415686,0.278431,0.192157},{0.231373,0.556863,0.556863},{0.168627,0.647059,0.67451},{0.286275,0.67451,0.694118},{0.160784,0.686275,0.698039},{0.12549,0.678431,0.690196},{0.113725,0.65098,0.658824},{0.152941,0.568627,0.556863},{0.321569,0.470588,0.415686},{0.396078,0.360784,0.290196},{0.290196,0.266667,0.207843},{0.32549,0.239216,0.176471},{0.364706,0.231373,0.156863},{0.4,0.262745,0.180392},{0.368627,0.239216,0.168627},{0.356863,0.231373,0.164706},{0.34902,0.227451,0.164706},{0.168627,0.345098,0.333333},{0.129412,0.372549,0.376471},{0.101961,0.431373,0.439216},{0.070588,0.478431,0.490196},{0.019608,0.545098,0.576471},{0.003922,0.54902,0.580392},{0.007843,0.541176,0.572549}}}

data.setName("display")
data.save("data",presets.moanalisa)

function generate()
    local c = 0
    for y = 1, SCREEN_RESOLUTION.x, 1 do
        for x = 1, SCREEN_RESOLUTION.y, 1 do
            c = c + 1
            clientData[c] = {x/SCREEN_RESOLUTION.x,y/SCREEN_RESOLUTION.y,0}
        end
    end
end

function compress(data)
    return vectors.rgbToINT(data)
end

function uncompress(data)
    return vectors.intToRGB(data)
end

function loadPreset(preset)
    clientData = preset
end


function setPixel(x,y,value)
    data["x"..x.."y"..y] = value
    model.SKULL["r"..y]["p"..x].setColor(value)
end

function forceUpdateDisplay(data)
    model.SKULL.LOADING_SCREEN.setEnabled(not isMediaLoaded)
    local c = 0
    for y = 1, SCREEN_RESOLUTION.y, 1 do
        for x = 1, SCREEN_RESOLUTION.x, 1 do
            c = c + 1
            if type(data[c]) == "table" then
                model.SKULL["r"..SCREEN_RESOLUTION.y-y + 1]["p"..x].setColor(data[c])
            end
        end
    end
end

function setScreenColor(tableColor)
    for y = 1, SCREEN_RESOLUTION.y, 1 do
        for x = 1, SCREEN_RESOLUTION.x, 1 do
            model.SKULL["r"..y]["p"..x].setColor(tableColor)
        end
    end
end

function compressClientData()
    unpackingInstruction = ""
    ClientCompressedData = ""
    local c = 1
    for _, value in pairs(clientData) do
        
        local item = compress(value)
        --if c == debugID then
        --    log("====================")
        --    log(string.len(item).." | "..item)
        --end
        ClientCompressedData = ClientCompressedData..item
        unpackingInstruction = unpackingInstruction..string.len(item)
        c = c + 1
    end
end
------=================== NETWORK BATCHING ===================------

network.registerPing("sendBatch")
network.registerPing("sendMetaData")
network.registerPing("finishedSent")

function player_init()
    loadPreset(presets.moanalisa)
    --generate()
    setScreenColor({0.05,0.05,0.05})
end

function tick()
    time = time + 1
    if not isMediaLoaded then
        model.SKULL.LOADING_SCREEN.cube.setRot{0,0,math.floor(time*0.5)*90}
        model.SKULL.LOADING_SCREEN.LOADING_CURRENT.setScale{(batchCount*batchSize)/targetBatchCount,1,1}
    end
    if client.isHost()then
        if isMediaBeingLoaded then
            timeSinceLastBatch = timeSinceLastBatch + 1
            if BatchSendingDelay < timeSinceLastBatch then
                timeSinceLastBatch = 0
                if batchCount == 0 then
                    compressClientData()
                    network.ping("sendMetaData",{targetBatchCount=math.ceil(string.len(ClientCompressedData))})
                    
                else
                    local count = (batchCount-1)*batchSize+1
                    if count > string.len(ClientCompressedData) then
                        network.ping("finishedSent",tostring("a"..unpackingInstruction))
                    else
                        --log("§a[§fBatch§a]§r : "..tostring(batchCount))
                        --log("§a[§fInst§a]§r : "..unpackingInstruction)
                        --log("§a[§fBatch§a]§r : "..batchCount)
                        --log(math.min((batchCount+1)*batchSize,string.len(ClientCompressedData)).." "..string.len(ClientCompressedData))
                        --sendBatch({batchCount,string.sub(ClientCompressedData,batchCount*batchSize,math.min((batchCount+1)*batchSize,string.len(ClientCompressedData)))})

                        local chunk = string.sub(ClientCompressedData,count,math.min((batchCount)*batchSize,string.len(ClientCompressedData)))
                        --if batchCount == 0 then
                        --    log("CHUNK: "..chunk)
                        --end

                        network.ping("sendBatch",{batchCount,chunk})

                    end
                end
                batchCount = batchCount + 1
            end
        end
    end
end

debugID = 1

time = 0

unpackingInstruction = ""

isMediaBeingLoaded = true
isMediaLoaded = false

batchCount = 0
batchSize = 40
targetBatchCount = 0

timeSinceLastBatch = 0
BatchSendingDelay = 1


function sendMetaData(metadata)
    isMediaBeingLoaded = true
    isMediaLoaded = false
    batchCount = 1
    targetBatchCount = metadata.targetBatchCount
    for i = 1, targetBatchCount, 1 do
        batches[i] = nil
    end
end

batches = {}

function sendBatch(chunk)
    --log("§a[§fFetch§a]§r : "..chunk[1])
    table.insert(batches,chunk[1],tostring(chunk[2]))
    --log(string.sub(tostring(chunk),2,9999))
    --logTableContent(batches)
end

function finishedSent(inst)
    unpackingInstruction = string.sub(inst,2,99999999)
    isMediaBeingLoaded = false
    isMediaLoaded = true
    --logTableContent(batches)
    compressedData = ""
    for _, value in pairs(batches) do
        compressedData = compressedData..tostring(value)
    end
    
    --log(ClientCompressedData)
    --log(compressedData)

    local c = 1
    local lc = 0
    local index = 0
    
    local len = string.len(unpackingInstruction)

    
    while index < len do
        index = index + 1
        lc = (c)
        
        --log(i)
        local ofst = tonumber(string.sub(unpackingInstruction,index,index))
        c = math.min(c + ofst,len)
        if lc == c then
            break
        end
        --log(i.." : "..tonumber(string.sub(unpackingInstruction,i,i)).." : "..string.sub(compressedData,d+1,c))

        log("lc: "..lc.." c: "..c)
        local result = uncompress(tonumber(string.sub(compressedData,lc,c-1)))
        
        --if index == debugID then
        --    log(ofst.." | "..string.sub(compressedData,lc,c-1))
        --end
        table.insert(rawData,{result.x,result.y,result.z})
    end
    --logTableContent(rawData)
    forceUpdateDisplay(rawData)
end
