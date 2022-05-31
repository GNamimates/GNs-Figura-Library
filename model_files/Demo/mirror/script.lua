--[[--============================================================================--
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
]]--============================================================================--[[
margin = 0.0001
renderDistance = 10
portalSize = {x=3,y=3}
portalRes = {x=64,y=64}

alwaysUpdate = true
lastCamPos = vectors.of{}

isUsingHotfix = false

pixelPathCache = {}
portalRot = 0
lowDetailMode = false


--====================================[ COMMAND ]====================================--
chat.setFiguraCommandPrefix("!scale")

function onCommand(cmd)
    local splitted = Split(cmd," ")
    if #splitted == 3 then
        ping.scalePortal({x=splitted[2],y=splitted[3]})
    else
        log("§cNot enough or too many arguments,\n format: !scale <x> <y>")
    end
end

function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

--====================================[ NETWORKING ]====================================--

ping.scalePortal = function (size)
    portalSize = size
    model.NO_PARENT.setScale({portalSize.x/(portalRes.x/16),portalSize.y/(portalRes.y/16),-0.01})
end

mirror_pos = vectors.of {}
ping.moveMirror = function(pos)
    mirror_pos = pos
    model.NO_PARENT.setPos(mirror_pos * vectors.of {-16, -16, 16})
    updateViewport()
end

ping.rotate = function (rotation)
    portalRot = rotation
end

data.setName("GN-mirror")
do
    local pos = data.load("pos")
    local rot = data.load("rot")
    if pos then
        ping.moveMirror(pos)
    end
    if rot then
        ping.rotate(rot)
    end
end

for y = 1, portalRes.y, 1 do
    for x = 1, portalRes.x, 1 do
        table.insert(pixelPathCache,model.NO_PARENT["x"..tostring(x-1).."y"..tostring(y-1)])
    end
end

--====================================[ ACTION WHEEL ]====================================--
action_wheel.SLOT_8.setItem("minecraft:glass_pane")
action_wheel.SLOT_8.setTitle("placeMirror")
action_wheel.SLOT_8.setFunction(function()
    if player.getTargetedBlockPos(false) then
        local pos = player.getTargetedBlockPos(false) + vectors.of {0, 1, 0}
    ping.moveMirror(pos)
    data.save("pos", pos)
    end
    
end)


action_wheel.SLOT_7.setItem("minecraft:magenta_glazed_terracotta")
action_wheel.SLOT_7.setTitle("Rotate")
action_wheel.SLOT_7.setFunction(function()
    if player.getTargetedBlockPos(false) then
        ping.rotate((portalRot+15)%360)
        data.save("rot",portalRot)
    end
end)

renderMode = 1
modes ={
    "final composition",
    "albedo map",
    "light map",
    "normal map",
    "update heatmap",
    "benchmark"
}

action_wheel.SLOT_6.setTitle("Toggle Render Mode: "..modes[renderMode])
action_wheel.SLOT_6.setItem("minecraft:glowstone")
action_wheel.SLOT_6.setFunction(function ()
    ping.switchRenderingMode((renderMode%6)+1)
end)

ping.switchRenderingMode = function (mode)
    renderMode = mode
    action_wheel.SLOT_6.setTitle("Toggle Render Mode: "..modes[renderMode])
    lastBuffer = {}
end

scatterMode = 1
scatterModeNames = {
    "clean",
    "noise"
}

action_wheel.SLOT_5.setTitle("Scatter Mode: "..scatterModeNames[scatterMode+1])
action_wheel.SLOT_5.setItem("minecraft:sugar")
action_wheel.SLOT_5.setFunction(function ()
    ping.switchRenderingScatter((scatterMode+1)%2)
end)


ping.switchRenderingScatter = function (mode)
    scatterMode = mode
    action_wheel.SLOT_5.setTitle("Scatter Mode: "..scatterModeNames[mode+1])
end

if meta.getFiguraVersion() == "0.0.8+1.18.2" then
    isUsingHotfix = true
end

updateFrame = true

function tick()
    model.NO_PARENT.setRot({0,portalRot})
    if updateFrame then
        updateViewport()
    end
end
lastBuffer = {}
finishedRenderingAFrame = true
updateCount = 0
updateCap = 10000 -- how many pixels to update per tick
updateQueue = {}
isFrameOdd = false -- used to benchmark the maximum fps of the screen
changesCount = 0--the higher the value, the more pixels changed, used to automatically turn on low detail mode

function updateViewport()
    
    currentCamPos = renderer.getCameraPos()
    updateCount = 0
    local index = 0
    if finishedRenderingAFrame then--triggers every time a new frame starts
        changesCount = 0
        color = {}
        updateQueue = {}
        local res = 1
        if lowDetailMode then
            res = 2
        end
        for y = 0, portalRes.y-1, res do
            for x = 1, portalRes.x, res do
                table.insert(updateQueue,{x,y})
            end
        end
        finishedRenderingAFrame = false
    end
    
    while #updateQueue ~= 0 and updateCap > updateCount do
        if scatterMode == 1 then--keeps clean scatter mode from warping, but allow warping in noise scatter
            currentCamPos = renderer.getCameraPos()
        end
        updateCount = updateCount + 1
        local targetTile = 1
        if scatterMode == 1 then
            targetTile = math.floor(math.random()*(#updateQueue-1))+1
        end
        value = updateQueue[targetTile]
        index = value[1]+(value[2])*portalRes.x
        table.remove(updateQueue,targetTile)

        if renderMode ~= 6 then--everything exept benchmark
            
            local x = value[1]
            local y = value[2]
            local pixelPos = mirror_pos+(vectors.of{math.cos(-math.rad(portalRot))*(x-0.5)*portalSize.x,(y+0.5)*portalSize.y,math.sin(-math.rad(portalRot))*(x-0.5)*portalSize.x}/vectors.of{portalRes.x,portalRes.y,portalRes.x})
            local rayTo = pixelPos+((currentCamPos-pixelPos)*vectors.of{-1,-1,-1}).normalized()*renderDistance
    
            local ray = renderer.raycastBlocks(pixelPos,rayTo, "VISUAL", "ANY")
            local finalColor = vectors.of{}
            
            if isUsingHotfix then
                finalColor = world.getBiome(currentCamPos).getSkyColor()
            end
            
            if ray then-- if the ray hits a bitch
                local rayDir = (pixelPos-rayTo).normalized()
                local LightingShading = 15
                local normalShading = 1
                local surfaceNormal = 1
                local targetPos = vectors.of{math.floor(ray.pos.x+rayDir.x*margin),math.floor(ray.pos.y+rayDir.y*margin),math.floor(ray.pos.z+rayDir.z*margin)}
                
                if renderMode == 1 or renderMode == 4 then-- final comp + normal map
                    local offset = targetPos-ray.pos+vectors.of{0.5,0.5,0.5}
                    surfaceNormal = 2
                    offset = vectors.of{math.abs(offset.x),math.abs(offset.y),math.abs(offset.z)}--normal shading
                    if math.abs(offset.x) > math.abs(offset.y) or math.abs(offset.z) > math.abs(offset.y) then
                        normalShading = 0.5
                        surfaceNormal = 1
                    end
                    if math.abs(offset.x) > math.abs(offset.z) and math.abs(offset.x) > math.abs(offset.y) then
                        normalShading = 0.4
                        surfaceNormal = 3
                    end
                end
                if renderMode ~= 2 and renderMode ~= 4 then-- albedo + normal map
                    LightingShading = math.max(world.getBlockLightLevel(targetPos),world.getSkyLightLevel(targetPos))
                end
                if renderMode == 3 then--light only
                    finalColor = vectors.of{LightingShading/15,LightingShading/15,LightingShading/15}
                end
                if renderMode == 1 or renderMode == 2 or renderMode == 5 then--final composition
                    finalColor = vectors.intToRGB(ray.state.getMapColor())*(LightingShading/15)*normalShading
                end
                if type(lastBuffer[index]) ~= "nil" then
                    if renderMode == 4 then-- normal map
                        if surfaceNormal == 1 then
                            pixelPathCache[index].setColor{1,0,0}
                        elseif surfaceNormal == 2 then
                            pixelPathCache[index].setColor{0,1,0}
                        elseif surfaceNormal == 3 then
                            pixelPathCache[index].setColor{0,0,1}
                        end
                    else
                        if lastBuffer[index].x ~= finalColor.x or lastBuffer[index].y ~= finalColor.y or lastBuffer[index].z ~= finalColor.z then
                            changesCount = changesCount + 1
                            pixelPathCache[index].setColor(finalColor)
                            if lowDetailMode then
                                pixelPathCache[index+1].setColor(finalColor)
                                pixelPathCache[index+portalRes.x].setColor(finalColor)
                                pixelPathCache[index+portalRes.x+1].setColor(finalColor)
                                lastBuffer[index+1]= finalColor
                                lastBuffer[index+portalRes.x] = finalColor
                                lastBuffer[index+portalRes.x+1] = finalColor
                            end
                        else
                            if renderMode == 5 then-- heatmap
                                pixelPathCache[index].setColor({0,0,0})
                            end
                        end
                        lastBuffer[index] = finalColor
                    end
                else
                    lastBuffer[index] = vectors.of{}
                end
            else
                if isUsingHotfix then--if ray hit no bitches
                    local skyColor = world.getBiome(currentCamPos).getSkyColor()
                    lastBuffer[index] = vectors.of{skyColor}
                    pixelPathCache[index].setColor(skyColor)
                    if lowDetailMode then
                        pixelPathCache[index+1].setColor(skyColor)
                        pixelPathCache[index+portalRes.x].setColor(skyColor)
                        pixelPathCache[index+portalRes.x+1].setColor(skyColor)
                        lastBuffer[index+1] = vectors.of{skyColor}
                        lastBuffer[index+portalRes.x] = vectors.of{skyColor}
                        lastBuffer[index+portalRes.x+1] = vectors.of{skyColor}
                    end
                else
                    pixelPathCache[index].setColor({})
                end
                lastBuffer[index] = vectors.of{}
            end
        else
            if isFrameOdd then
                pixelPathCache[index].setColor({})
            else
                pixelPathCache[index].setColor({0.1,0.1,0.1})
            end
        end
    end
    if #updateQueue == 0 then--triggers when a frame finishes
        lowDetailMode = (changesCount > 50)
        finishedRenderingAFrame = true
        isFrameOdd = not isFrameOdd
    end
    updateFrame = true
end

function player_init()
    local format = "POSITION_COLOR_TEXTURE_OVERLAY_LIGHT_NORMAL"
    local vertexSource = [==[
    #version 150

    in vec3 Position;
    in vec4 Color;
    in vec2 UV0;
    in ivec2 UV1;
    in ivec2 UV2;
    in vec3 Normal;

    uniform sampler2D Sampler1; //Overlay Sampler
    uniform sampler2D Sampler2; //Lightmap Sampler

    uniform mat4 ModelViewMat;
    uniform mat4 ProjMat;

    uniform vec3 Light0_Direction;
    uniform vec3 Light1_Direction;

    out float vertexDistance;
    out vec4 vertexColor;
    out vec4 lightMapColor;
    out vec4 overlayColor;
    out vec2 texCoord0;
    out vec4 normal;

    void main() {
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
        vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
        vertexColor = Color;
        texCoord0 = vec2(0,0);
        normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
          }
        ]==]
        local fragmentSource = [==[
    #version 150

    uniform sampler2D Sampler0;

    uniform vec4 ColorModulator;
    uniform float FogStart;
    uniform float FogEnd;
    uniform vec4 FogColor;

    in float vertexDistance;
    in vec4 vertexColor;
    in vec4 lightMapColor;
    in vec4 overlayColor;
    in vec2 texCoord0;
    in vec4 normal;

    out vec4 fragColor;

    void main() {
        fragColor = vertexColor;
    }
    ]==]
    renderlayers.registerShader("noShade", format, vertexSource, fragmentSource, 1, {})
    local intro = function()
        renderlayers.useShader("noShade")
        renderlayers.enableDepthTest()
        renderlayers.disableCull()
    end
    local outro = function()
        renderlayers.restoreDefaults()
    end
    renderlayers.registerRenderLayer("fullBrightL", {}, intro, outro)
    model.NO_PARENT.setRenderLayer("fullBrightL")
end

function angleToDir(direction)
    if type(direction) == "table" then
        direction = vectors.of{direction}
    end
    return vectors.of({
        math.cos(math.rad(direction.y+90))*math.cos(math.rad(direction.x)),
        math.sin(math.rad(-direction.x)),
        math.sin(math.rad(direction.y+90))*math.cos(math.rad(direction.x))
    })
end