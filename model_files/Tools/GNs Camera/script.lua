--[[--====================================================================---------
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
--=================================================================================]]--
version = 0.2

config = {
    display = {
        show_model_controllers = true,

        controller_strand_detail = 0.25,-- the lower the number, the more details

        trace_path = true,-- toggles on/off the path trace display
        particle_path = false,
        path_subdivisions = 5,-- basically higher number = more detail
    },
    workspace = {
        clamp_transition_weights = true, -- if true, the transition weights will be clamped to 0-1, keeping the track from jittering
        force_reset_workspace = false, -- resets the workspace everytime
    },
    cache = {
        resolution = 60,--kinda like fps
    },
    theme = {
        normal = {
            color = "white",
            prefix = "",
        },
        highlight = {
            color = "red",
            prefix = "> "
        },
    }
}
modified = false
currentPresetName = "Untitled"

workspace = {
    keyframe = {},
    time = 0,
    playbackSpeed = 1,
    duration = 0,
    trackMode = true,
    playing = false,
}

lastKeyframeDuration = 1
weight = 0 --lerp
KeyframeDuration = 1
KeyframeIndexBefore = 1
KeyframeIndexAfter = 1

lastPathDuration = 1
PathDuration = 1
PathIndexBefore = 1
PathIndexAfter = 1

data.setName("GN.camera")
tickRate = 20
tickspeed = 1/tickRate
function intro()
    --log("§6GN's Camera v"..tostring(version))
end


waitingForConfName = ""
function safeSavePreset(name,forced)-- checks if the name is valid and if it is, saves the preset
    if not presetExists(name) or forced then
        savePreset(name)
    else
        switchPage(menu.saveConfirmation)
    end
end

function clearKeyframes()
    workspace.keyframe = {}
end

function addPoint(pos,rot,controller,type,time)-- adds a point to the keyframe list
    for index, p in pairs(workspace.keyframe) do--insertion sort
        if workspace.duration < time then
            workspace.duration = time
        end
        if p.time > time then
            table.insert(workspace.keyframe,index,{pos=vectors.of{pos},rot=vectors.of{rot},ctrl=vectors.of{controller},type=type,time=time})
            return
        end
    end
    table.insert(workspace.keyframe,{pos=vectors.of{pos},rot=vectors.of{rot},ctrl=vectors.of{controller},type=type,time=time})
end

function saveWorkspace()--saves the current workspace(not in the preset)
    local package = {keyframes={}}
    package.state = {
        workspace.duration,
        workspace.time,
        workspace.playbackSpeed
    }
    for index, keyframe in pairs(workspace.keyframe) do
        package.keyframes[index] = {
            pos = {keyframe.pos.x,keyframe.pos.y,keyframe.pos.z},
            rot = {keyframe.rot.x,keyframe.rot.y,keyframe.rot.z},
            ctrl = {keyframe.ctrl.x,keyframe.ctrl.y,keyframe.ctrl.z},
            type = keyframe.type,
            time = keyframe.time
        }
    end
    data.save("workspace",package)
    log("saved workspace")
end

function savePreset(name)--saves the current preset
    data.setName("GN.camera.preset."..name)
    local package = {keyframes={}}
    package.state = {
        workspace.duration,
        workspace.time,
        workspace.playbackSpeed
    }
    for index, keyframe in pairs(workspace.keyframe) do
        package.keyframes[index] = {
            pos = {keyframe.pos.x,keyframe.pos.y,keyframe.pos.z},
            rot = {keyframe.rot.x,keyframe.rot.y,keyframe.rot.z},
            ctrl = {keyframe.ctrl.x,keyframe.ctrl.y,keyframe.ctrl.z},
            type = keyframe.type,
            time = keyframe.time
        }
    end
    data.save("data",package)
    log("saved preset")
end

function loadPreset(name)--saves the current preset
    data.setName("GN.camera.preset."..name)
    local loaded = data.load("data")
    local package = {keyframes={}}
    workspace.duration = tonumber(loaded.state[1])
    workspace.time = tonumber(loaded.state[2])
    workspace.playbackSpeed = tonumber(loaded.state[3])
    
    for index, keyframe in pairs(loaded.keyframe) do
        package.keyframes[index] = {
            pos = {tonumber(keyframe.pos[1]),tonumber(keyframe.pos[2]),tonumber(keyframe.pos[3])},
            rot = {tonumber(keyframe.rot[1]),tonumber(keyframe.rot[2]),tonumber(keyframe.rot[3])},
            ctrl = {tonumber(keyframe.ctrl[1]),tonumber(keyframe.ctrl[2]),tonumber(keyframe.ctrl[3])},
            type = keyframe.type,
            time = tonumber(keyframe.time)
        }
    end
    log("Preset Loaded")
end

function presetExists(name)
    local temp = data.getName()
    data.setName("GN.camera.preset."..name)
    if data.load("data") then
        data.setName(temp)
        return true
    else
        data.setName(temp)
        return false
    end
end

function safeLoadWorkspace()
    local storedWorkspace = data.load("workspace")
    if not storedWorkspace or config.workspace.force_reset_workspace then
        workspace = {
            keyframe = {},
            time = 0,
            playbackSpeed = 1,
            duration = 0,
            trackMode = false,
            playing = false,
        }
        addPoint({-7.5,4,45},{0,-90,0},{0,0,2},"smooth",0)
        addPoint({-4,3,43},{0,0,0},{-4,0,0},"smooth",2)
        addPoint({0,7,45},{0,90,0},{0,0,-2},"smooth",4)
        addPoint({-4,2,48},{0,180,0},{4,0,0},"smooth",6)
        addPoint({-7.5,4,45},{0,270,0},{0,0,2},"smooth",8)
        log("workspace missing.. loading default template")
        saveWorkspace()
    else
        workspace = {
            trackMode = false,
            playing = false,
        }
        workspace.duration = tonumber(storedWorkspace.state["1"])
        workspace.time = tonumber(storedWorkspace.state["2"])
        workspace.playbackSpeed = tonumber(storedWorkspace.state["3"])
        workspace.keyframe = {}
        for index, keyframe in pairs(storedWorkspace.keyframes) do
            addPoint(
                vectors.of{tonumber(keyframe.pos["1"]),tonumber(keyframe.pos["2"]),tonumber(keyframe.pos["3"])},
                vectors.of{tonumber(keyframe.rot["1"]),tonumber(keyframe.rot["2"]),tonumber(keyframe.rot["3"])},
                vectors.of{tonumber(keyframe.ctrl["1"]),tonumber(keyframe.ctrl["2"]),tonumber(keyframe.ctrl["3"])},
                keyframe.type,tonumber(keyframe.time))
        end
    end
    updateKeyframeDisplay()
    updateTracedPath()
    initialize_menu()
end

function loadWorkspace()
    local storedWorkspace = data.load("workspace")
    if not storedWorkspace or config.workspace.force_reset_workspace then
        resetWorkspace()
    else
        loadWorkspace()
    end
end

function resetWorkspace()
    workspace = {
        keyframe = {},
        time = 0,
        playbackSpeed = 1,
        duration = 0,
        trackMode = false,
        playing = false,
    }
    addPoint({-7.5,4,45},{0,-90,0},{0,0,2},"smooth",0)
    addPoint({-4,3,43},{0,0,0},{-4,0,0},"smooth",2)
    addPoint({0,7,45},{0,90,0},{0,0,-2},"smooth",4)
    addPoint({-4,2,48},{0,180,0},{4,0,0},"smooth",6)
    addPoint({-7.5,4,45},{0,270,0},{0,0,2},"smooth",8)
    log("workspace missing.. loading default template")
    saveWorkspace()
end

function loadWorkspace()
    storedWorkspace = data.load("workspace")
    workspace = {
        trackMode = false,
        playing = false,
    }
    workspace.duration = tonumber(storedWorkspace.state["1"])
    workspace.time = tonumber(storedWorkspace.state["2"])
    workspace.playbackSpeed = tonumber(storedWorkspace.state["3"])
    workspace.keyframe = {}
    for index, keyframe in pairs(storedWorkspace.keyframes) do
        addPoint(
            vectors.of{tonumber(keyframe.pos["1"]),tonumber(keyframe.pos["2"]),tonumber(keyframe.pos["3"])},
            vectors.of{tonumber(keyframe.rot["1"]),tonumber(keyframe.rot["2"]),tonumber(keyframe.rot["3"])},
            vectors.of{tonumber(keyframe.ctrl["1"]),tonumber(keyframe.ctrl["2"]),tonumber(keyframe.ctrl["3"])},
            keyframe.type,tonumber(keyframe.time))
    end
    updateKeyframeDisplay()
    updateTracedPath()
    initialize_menu()
    log("loaded workspace")
end

function player_init()
    intro()
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
          texCoord0 = UV0;
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
            vec4 color = texture(Sampler0, texCoord0);
            color *= vertexColor;
            fragColor = vec4(color);
        }
      ]==]
          renderlayers.registerShader("noShade", format, vertexSource, fragmentSource, 1, {})
          local intro = function()
              renderlayers.useShader("noShade")
              renderlayers.setTexture(0, "MY_TEXTURE")
              renderlayers.enableDepthTest()
              renderlayers.disableCull()
          end
          local outro = function()
            renderlayers.restoreDefaults()
          end
          renderlayers.registerRenderLayer("NoShade", {}, intro, outro)
    --for key, value in pairs(model) do
    --    value.setRenderLayer("NoShade")
    --end
    
    --addPoint({4,0,0},{},{0,0,-2},0)
    --addPoint({0,0,2},{},{2,0,0},1)
    --addPoint({-2,0,0},{},{0,0,2},2)
    --addPoint({0,0,-2},{},{-2,0,0},3)
    --addPoint({4,0,0},{},{0,0,-2},4)

    --addPoint({2,0,0},{},{0,0,2},0)
    --addPoint({-2,0,0},{},{0,0,2},2)
    safeLoadWorkspace()
end

vectors.toWorld = vectors.of{-16,-16,16}

function tick()
    if workspace.playing then
        workspace.time = workspace.time + workspace.playbackSpeed/tickRate
        workspace.time = workspace.time % workspace.duration
    end
    
    --time = math.lerp(0,duration,math.random())
    if config.display.show_particle_controllers then
        for key, value in pairs(workspace.keyframe) do
            particle.addParticle("dust",value.pos,config.theme.keyframe.origin)
            particle.addParticle("dust",value.pos+value.ctrl,config.theme.keyframe.controller)
            particle.addParticle("dust",value.pos-value.ctrl,config.theme.keyframe.controller)
            local subdivision = config.display.controller_strand_detail/value.ctrl.getLength()
            for i = -1+subdivision, 1-subdivision, subdivision do
                if i ~= 0 then
                    particle.addParticle("dust",value.pos-value.ctrl*i,config.theme.keyframe.strand)
                end
            end
            --particle.addParticle("dust",value.pos-(value.ctrl*2)*(weight)+value.ctrl,config.theme.keyframe.controller)
        end
    end
end

function updateKeyframeDisplay()
    if config.display.show_model_controllers then
        for index, v in pairs(workspace.keyframe) do
            model["NO_PARENT_KEYFRAME"..tostring(index)].setPos(v.pos*vectors.toWorld)
            model["NO_PARENT_KEYFRAME"..tostring(index)]["STRAND"..tostring(index)].setRot(lookat(v.ctrl))
            model["NO_PARENT_KEYFRAME"..tostring(index)]["STRAND"..tostring(index)].setScale({1,v.ctrl.getLength(),1})
            model["NO_PARENT_KEYFRAME"..tostring(index)]["CONTROLLER_A"..tostring(index)].setPos(v.ctrl*vectors.toWorld)
            model["NO_PARENT_KEYFRAME"..tostring(index)]["CONTROLLER_B"..tostring(index)].setPos(v.ctrl*vectors.toWorld*-1)
            model["NO_PARENT_KEYFRAME"..tostring(index)].setEnabled(true)
        end
        for i = #workspace.keyframe, 1000, 1 do
            if model["NO_PARENT_KEYFRAME"..tostring(i)] then
                model["NO_PARENT_KEYFRAME"..tostring(i)].setEnabled(false)
            else
                break
            end
        end
    else
        for i = 1, 100, 1 do
            if model["NO_PARENT_KEYFRAME"..tostring(i)] then
                model["NO_PARENT_KEYFRAME"..tostring(i)].setEnabled(false)
            else
                break
            end
        end
    end
end

function updateTracedPath()
    if config.display.trace_path and not config.display.particle_path then
        local index = 0
        if workspace.keyframe[1] then
            local lastPos = workspace.keyframe[1].pos
            for t = 0, workspace.duration, 1/config.display.path_subdivisions do
                index = index + 1
                if not model["NO_PARENT_PATH"..tostring(index)] then
                    break
                end
                for index, value in pairs(workspace.keyframe) do
                    if value.time > t then
                        PathIndexBefore = index
                        PathIndexAfter = index-1
                        if index ~= 1 then
                            if workspace.keyframe[index].time-workspace.keyframe[index-1].time ~= PathDuration then
                                lastPathDuration = PathDuration
                                PathDuration = workspace.keyframe[index].time-workspace.keyframe[PathIndexAfter].time
                            end
                        else
                            if workspace.keyframe[index].time-workspace.keyframe[index-1].time ~= PathDuration then
                                lastPathDuration = PathDuration
                                PathDuration = workspace.keyframe[index].time
                            end
                        end
                        break
                    end
                end
    
                local weight = ((t-workspace.keyframe[PathIndexBefore].time)*(1/PathDuration))*-1
                --local pos = vectors.lerp(
                --    vectors.lerp(
                --        vectors.lerp(
                --            keyframe[PathIndexBefore].pos,
                --            keyframe[PathIndexBefore].pos+keyframe[PathIndexBefore].ctrl*2,
                --            weight),
                --        vectors.lerp(
                --            keyframe[PathIndexBefore].pos+keyframe[PathIndexBefore].ctrl*2,
                --            keyframe[PathIndexAfter].pos,
                --            weight),
                --        weight
                --    ),
                --    vectors.lerp(
                --        vectors.lerp(keyframe[PathIndexBefore].pos,
                --        keyframe[PathIndexAfter].pos-keyframe[PathIndexAfter].ctrl*2,
                --        weight),
                --        vectors.lerp(keyframe[PathIndexAfter].pos-keyframe[PathIndexAfter].ctrl*2,
                --        keyframe[PathIndexAfter].pos,
                --        weight),
                --        weight
                --    ),
                --    weight
                --)
                local pos = vectors.of{
                    cubicBezierCurve(workspace.keyframe[PathIndexBefore].pos.x,workspace.keyframe[PathIndexBefore].pos.x+workspace.keyframe[PathIndexBefore].ctrl.x,workspace.keyframe[PathIndexAfter].pos.x-workspace.keyframe[PathIndexAfter].ctrl.x,workspace.keyframe[PathIndexAfter].pos.x,weight),
                    cubicBezierCurve(workspace.keyframe[PathIndexBefore].pos.y,workspace.keyframe[PathIndexBefore].pos.y+workspace.keyframe[PathIndexBefore].ctrl.y,workspace.keyframe[PathIndexAfter].pos.y-workspace.keyframe[PathIndexAfter].ctrl.y,workspace.keyframe[PathIndexAfter].pos.y,weight),
                    cubicBezierCurve(workspace.keyframe[PathIndexBefore].pos.z,workspace.keyframe[PathIndexBefore].pos.z+workspace.keyframe[PathIndexBefore].ctrl.z,workspace.keyframe[PathIndexAfter].pos.z-workspace.keyframe[PathIndexAfter].ctrl.z,workspace.keyframe[PathIndexAfter].pos.z,weight)
                }
                model["NO_PARENT_PATH"..tostring(index)].setPos(pos*vectors.toWorld)
                model["NO_PARENT_PATH"..tostring(index)].setRot(lookat(lastPos-pos))
                model["NO_PARENT_PATH"..tostring(index)].setScale{1,(lastPos-pos).getLength(),1}
                model["NO_PARENT_PATH"..tostring(index)].setEnabled(true)
                lastPos = pos
            end
        end
    else
        for i = 1, 1000, 1 do
            if model["NO_PARENT_PATH"..tostring(i)] then
                model["NO_PARENT_PATH"..tostring(i)].setEnabled(false)
            end
        end
    end
end

function cubicBezierCurve(a,b,c,d,t)
    local t2 = t*t
    local t3 = t2*t
    return a*(1-t3+3*t2-3*t)+b*(3*t3-6*t2+3*t)+c*(-3*t3+3*t2)+d*t3 
end

--[[ CLASSIC LERP
function world_render(delta)
    local t = time+delta*speed-tickspeed
    if playing then
        findClosestKeyframes()
        local weight = (t-keyframe[keyframeIndexBefore].time)*(1/keyframeDuration)
        local pos = vectors.lerp(keyframe[keyframeIndexBefore].pos,keyframe[keyframeIndexAfter].pos,weight)
        local rot = vectors.lerp(keyframe[keyframeIndexBefore].rot,keyframe[keyframeIndexAfter].rot,weight)
        particle.addParticle("minecraft:dust",pos,{1,0,0,1})
        --cam(pos,rot,delta)
    end
end
]]

key = {}
key.primary = keybind.newKey("Select","MOUSE_BUTTON_1",true)
wasPrimary = false
key.getSelectedKeyframe = keybind.newKey("Select Keyframe","MOUSE_BUTTON_2",false)

trackCamera = {
    pos = vectors.of{},
    rot = vectors.of{}
}

function world_render(delta)--lerp hell
    local t = workspace.time+delta*(workspace.playbackSpeed/tickRate)
    if workspace.playing then
        for index, value in pairs(workspace.keyframe) do
            if tonumber(value.time) > workspace.time then
                KeyframeIndexAfter = index
                KeyframeIndexBefore = index-1
                if index ~= 1 then
                    if workspace.keyframe[index].time-workspace.keyframe[index-1].time ~= KeyframeDuration then
                        lastKeyframeDuration = KeyframeDuration
                        KeyframeDuration = workspace.keyframe[index].time-workspace.keyframe[index-1].time
                    end
                else
                    if workspace.keyframe[index].time-workspace.keyframe[index-1].time ~= KeyframeDuration then
                        lastKeyframeDuration = KeyframeDuration
                        KeyframeDuration = workspace.keyframe[index].time
                    end
                end
                break
            end
        end

        weight = (t-workspace.keyframe[KeyframeIndexBefore].time)*(1/KeyframeDuration)
        --weight = weight+timeModifier
        if config.workspace.clamp_transition_weights then
            weight = math.clamp(weight,0,1)
        end
        --graph((1+timeModifier)*10)
        local pos = vectors.of{
            cubicBezierCurve(workspace.keyframe[KeyframeIndexBefore].pos.x,workspace.keyframe[KeyframeIndexBefore].pos.x-workspace.keyframe[KeyframeIndexBefore].ctrl.x,workspace.keyframe[KeyframeIndexAfter].pos.x+workspace.keyframe[KeyframeIndexAfter].ctrl.x,workspace.keyframe[KeyframeIndexAfter].pos.x,weight),
            cubicBezierCurve(workspace.keyframe[KeyframeIndexBefore].pos.y,workspace.keyframe[KeyframeIndexBefore].pos.y-workspace.keyframe[KeyframeIndexBefore].ctrl.y,workspace.keyframe[KeyframeIndexAfter].pos.y+workspace.keyframe[KeyframeIndexAfter].ctrl.y,workspace.keyframe[KeyframeIndexAfter].pos.y,weight),
            cubicBezierCurve(workspace.keyframe[KeyframeIndexBefore].pos.z,workspace.keyframe[KeyframeIndexBefore].pos.z-workspace.keyframe[KeyframeIndexBefore].ctrl.z,workspace.keyframe[KeyframeIndexAfter].pos.z+workspace.keyframe[KeyframeIndexAfter].ctrl.z,workspace.keyframe[KeyframeIndexAfter].pos.z,weight)
        }
        trackCamera.pos = pos
        trackCamera.rot = vectors.lerp(
            vectors.lerp(
                vectors.lerp(
                    workspace.keyframe[KeyframeIndexBefore].rot,
                    workspace.keyframe[KeyframeIndexBefore].rot,
                    weight),
                vectors.lerp(
                    workspace.keyframe[KeyframeIndexBefore].rot,
                    workspace.keyframe[KeyframeIndexAfter].rot,
                    weight),
                weight
            ),
            vectors.lerp(
                vectors.lerp(workspace.keyframe[KeyframeIndexBefore].rot,
                workspace.keyframe[KeyframeIndexAfter].rot,
                weight),
                vectors.lerp(workspace.keyframe[KeyframeIndexAfter].rot,
                workspace.keyframe[KeyframeIndexAfter].rot,
                weight),
                weight
            ),
            weight
        )
    end
    if workspace.trackMode then
        cam(trackCamera.pos,trackCamera.rot,delta)
        model.NO_PARENT_PATHCAM.setEnabled(false)
    else
        model.NO_PARENT_PATHCAM.setPos(trackCamera.pos*vectors.toWorld)
        model.NO_PARENT_PATHCAM.setEnabled(true)
        camera.FIRST_PERSON.setPos({})
        camera.FIRST_PERSON.setRot({})
    end
end

function initialize_menu()
    refreashMenuDisplay()
end

function updateMenuDisplay()
    for index, value in pairs(currentMenu) do
        local prefix = ""
        local color = "white"
        local shadow_color = "dark_gray"
        if index == UISelected then
            if value.type == "margin" then
                UISelected = UISelected - mouseScroll
                UISelected = ((UISelected-1) % #currentMenu)+1
                updateMenuDisplay()
            else
                prefix = "> "
                if canScrollThoughMenu then
                    color = "red"
                    shadow_color = "dark_red"
                else
                    color = "green"
                    shadow_color = "dark_green"
                end
            end
        end
        if value.type ~= "margin" then
            if value.init then
                value.init(index)
            end
            local pd = ""
            if value.propertyDisplay then
                pd = value.propertyDisplay
            end
            if value.type == "text edit" then
                model.HUD.getRenderTask(index).setText('[{"color":"'..color..'","text":"'..prefix..value.name..": "..'"},{"underlined":true,"color":"'..color..'","text":"'..pd..'"}]')
                model.HUD.getRenderTask(index+0.5).setText('[{"color":"'..shadow_color..'","text":"'..prefix..value.name..": "..'"},{"underlined":true,"color":"'..shadow_color..'","text":"'..pd..'"}]')
            else
                if value.type == "label" then
                    model.HUD.getRenderTask(index).setText('{"color":"'..color..'","text":"'..prefix..value.name..'"}')
                    model.HUD.getRenderTask(index+0.5).setText('{"color":"'..shadow_color..'","text":"'..prefix..value.name'"}')
                else
                    model.HUD.getRenderTask(index).setText('{"color":"'..color..'","text":"'..prefix..value.name.." "..pd..'"}')
                    model.HUD.getRenderTask(index+0.5).setText('{"color":"'..shadow_color..'","text":"'..prefix..value.name.." "..pd..'"}')
                end
            end
        end
    end
end
--------=========================================================================================--
function tick()
    if key.getSelectedKeyframe.isPressed() ~= key.getSelectedKeyframe["wasPressed"] then
        if key.getSelectedKeyframe.isPressed() then
            local found = seekClosestKeyframe(renderer.getCameraPos(),player.getLookDir(),1)
            if found then
                model.NO_PARENT_SELECTION.setPos(workspace.keyframe[found].pos*vectors.toWorld)
            end
        end
    end
    key.getSelectedKeyframe["wasPressed"] = key.getSelectedKeyframe.isPressed()
end
--------=========================================================================================--
menu = {
    hidden = {
        {
            type="button",
            name="[GNs Camera] v"..tostring(version),
            trigger = function (id) switchPage(menu.general) end,
        },
    },
    general = {
        {
            type="button",
            name="[GNs Camera] v"..tostring(version),
            trigger = function (id) switchPage(menu.hidden) end,
        },
        {
            type="margin",
        },
        {
            type="toggle button",
            name="Playing",
            propertyDisplay="[on ⬛]",
            trigger = function (id) workspace.playing = not workspace.playing currentMenu[id].propertyDisplay = display.boolean(workspace.playing) end,
            init = function (id) currentMenu[id].propertyDisplay = display.boolean(workspace.playing) end
        },
        {
            type="toggle button",
            name="Track Mode",
            propertyDisplay="[on ⬛]",
            trigger = function (id) workspace.trackMode = not workspace.trackMode currentMenu[id].propertyDisplay = display.boolean(workspace.trackMode)  end,
            init = function (id) currentMenu[id].propertyDisplay = display.boolean(workspace.trackMode) end
        },
        {
            type="scroll",
            name="Playback Speed",
            propertyDisplay ="[x1]",
            trigger = function (id) canScrollThoughMenu = not canScrollThoughMenu end,
            hovering = function (id) 
                if mouseScroll ~= 0 and not canScrollThoughMenu then 
                    if mouseScroll == 1 then 
                        workspace.playbackSpeed = workspace.playbackSpeed * 2 
                    else 
                        workspace.playbackSpeed = workspace.playbackSpeed * 0.5
                    end 
                    currentMenu[id].propertyDisplay = "[x"..tostring(workspace.playbackSpeed).."]"
                    sound.playSound("minecraft:ui.button.click",player.getPos(),{1,math.sqrt(workspace.playbackSpeed)*0.01+0.7})
                    updateMenuDisplay()
                end
            end
        },
        {
            type="margin",
        },
        {
            type="button",
            name="Settings",
            trigger = function (id) switchPage(menu.settings) end,
        },
        {
            type="margin"
        },
        {
            type="text edit",
            name="Preset Name",
            propertyDisplay="Untitled",
            lastProperty="",
            trigger = function (id)
                canScrollThoughMenu = not canScrollThoughMenu
                if not canScrollThoughMenu then
                    currentMenu[id].lastProperty = currentMenu[id].propertyDisplay
                    chat.setFiguraCommandPrefix("")
                else
                    if not currentMenu[id].propertyDisplay then
                        currentMenu[id].propertyDisplay = currentMenu[id].lastProperty
                    end
                    currentPresetName = currentMenu[id].propertyDisplay 
                    chat.setFiguraCommandPrefix() 
                end
            end,
            hovering = function (id) if not canScrollThoughMenu then currentMenu[id].propertyDisplay = chat.getInputText() updateMenuDisplay() end end
        },
        {
            type="button",
            name="Save Preset",
            trigger = function () safeSavePreset(currentPresetName,false) end
        }
    },
    settings = {
        {
            type="button",
            name="[GNs Camera] v"..tostring(version),
            trigger = function (id) switchPage(menu.hidden) end,
        },
        {
            type="button",
            name="back to main menu",
            trigger = function (id) switchPage(menu.hidden) end,
        },
        {
            type="margin"
        },
        {
            type="toggle button",
            name="Show Path",
            propertyDisplay="[on ⬛]",
            trigger = function (id) config.display.trace_path = not config.display.trace_path currentMenu[id].propertyDisplay = display.boolean(config.display.trace_path) updateTracedPath() end
        },
        {
            type="toggle button",
            name="Show Keyframes",
            propertyDisplay="[on ⬛]",
            trigger = function (id) config.display.show_model_controllers = not config.display.show_model_controllers currentMenu[id].propertyDisplay = display.boolean(config.display.show_model_controllers) updateKeyframeDisplay() end
        },
    },
    saveConfirmation = {
        {
            type="button",
            name="[GNs Camera] v"..tostring(version),
            trigger = function (id) switchPage(menu.hidden) end,
        },
        {
            type="button",
            name=tostring(waitingForConfName)..'already exists. Overwrite?',
        },
        {
            type="margin",
        },
        {
            type="button",
            name="Overwrite",
            trigger = function (id) savePreset(waitingForConfName) switchPage(menu.general) end,
        },
        {
            type="button",
            name="Cancel",
            trigger = function (id) switchPage(menu.general) end,
        },
    },
    keyframeEditor = {
        {
            type="button",
            name="[GNs Camera] v"..tostring(version),
            trigger = function (id) switchPage(menu.hidden) end,
        },
        {
            type="button",
            name="back to main menu",
            trigger = function (id) switchPage(menu.hidden) end,
        },
    }
}
UISelected = 1
currentMenu = menu.hidden
canScrollThoughMenu = true

display = {}

function refreashMenuDisplay()
    model.HUD.clearAllRenderTasks()
    for key, value in pairs(currentMenu) do
        if value.type ~= "margin" then--skip margins
            model.HUD.addRenderTask("TEXT",key,"loading...",true,{0,(key-1)*3,0})
            model.HUD.addRenderTask("TEXT",key+0.5,"loading...",true,{0,(key-1)*3+0.4,1})
        end
    end
    model.HUD.addRenderTask("BLOCK","dog","stone",true,{0,999999999})--text not rendering fix
    updateMenuDisplay()
end

function switchPage(page)
    UISelected = 1
    currentMenu = page
    refreashMenuDisplay()
end

function display.boolean(toggle)
    if toggle then return "[on ⬛]" else return "[⬛off]" end 
end
beforeChatIsOpen = false
function tick()
    mouseScroll = client.getMouseScroll()
    model.HUD.setEnabled(chat.isOpen())
    if chat.isOpen() then
        if wasPrimary ~= key.primary.isPressed() then
            if key.primary.isPressed() then
                if currentMenu[UISelected].trigger then
                    sound.playSound("minecraft:ui.button.click",player.getPos())
                    currentMenu[UISelected].trigger(UISelected)
                    updateMenuDisplay()
                end
            end
            wasPrimary = key.primary.isPressed()
        end
        if currentMenu[UISelected].hovering then
            currentMenu[UISelected].hovering(UISelected)
        end
        
        if mouseScroll ~= 0 and canScrollThoughMenu then
            UISelected = UISelected - mouseScroll
            UISelected = ((UISelected-1) % #currentMenu)+1
            sound.playSound("minecraft:block.note_block.hat",player.getPos(),{1,UISelected/#currentMenu+0.5})
            updateMenuDisplay()
        end

        model.HUD.setPos(anchor({-1,-1},{0,0}))
        local a = client.getScaleFactor()*0.5
        model.HUD.setScale{1.5/a,1.5/a,1}
    else
        if beforeChatIsOpen then
            if currentMenu[UISelected].trigger and currentMenu[UISelected].type == "text edit" and not canScrollThoughMenu then
                sound.playSound("minecraft:ui.button.click",player.getPos())
                currentMenu[UISelected].trigger(UISelected)
                updateMenuDisplay()
            end
        end
    end
    beforeChatIsOpen = chat.isOpen()
end

function cam(pos,rot,delta)
    if type(pos) == "table" then pos = vectors.of(pos) end
    local r = player.getRot(delta)
    camera.FIRST_PERSON.setRot(vectors.of{{-r.x,-r.y,r.z}}+rot)
    r = r + camera.FIRST_PERSON.getRot()
    local p = pos-player.getPos(delta)-vectors.of({0, player.getEyeHeight()})
    local z = 1/math.cos(math.rad(r.x))*(math.cos(math.rad(r.y))*-p.z+math.sin(math.rad(r.y))*p.x)
    camera.FIRST_PERSON.setPos({
        math.min(math.max(math.cos(math.rad(r.y-90))*-p.z+math.sin(math.rad(r.y-90))*p.x, -500), 500),
        math.min(math.max(p.y-math.sin(math.rad(r.x))*z, -500), 500),math.min(math.max(z, -500), 500) })
end

function graph(num)
    log(string.rep("-",num).."|")
end

function lookat(pos)
    if type(pos) == "table" then pos = vectors.of(pos) end
    local y = math.atan2(pos.x,pos.z)
    local result = vectors.of({math.atan2((math.sin(y)*pos.x)+(math.cos(y)*pos.z),pos.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end

function angleToBasis(direction)
    if type(direction) == "table" then direction = vectors.of{direction} end
    return vectors.of({
        math.cos(math.rad(direction.y+90))*math.cos(math.rad(direction.x)),
        math.sin(math.rad(-direction.x)),
        math.sin(math.rad(direction.y+90))*math.cos(math.rad(direction.x))
    })
end
--changelog:
--tables are accepted now

function anchor(screen_coord,offset)
    return ((client.getWindowSize()*vectors.of{screen_coord[1],screen_coord[2]})/5)/client.getScaleFactor()+vectors.of{offset[1],offset[2]}
end

function getClosestKeyframe(pos,searchDistance)
    local closest = nil
    local closestDist = 999999999
    for key, value in pairs(workspace.keyframe) do
        local dist = vectors.of{pos}.distanceTo(value.pos)
        if dist < closestDist and dist < searchDistance then
            closestDist = dist
            closest = key
        end
    end
    return closest
end

function seekClosestKeyframe(pos,dir,searchDistance)
    for index = 1, 40, 1 do
        pos = pos + dir
        local closest = getClosestKeyframe(pos,searchDistance)
        if closest then return closest end
    end
end