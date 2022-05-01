--[[--============================================================================--
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
]]--============================================================================--[[

    scale = 0.6

    model.base.setScale{scale,scale,scale}
    model.base.setPos({0,40,0})
    
    animation.idle.setBlendTime(0)
    animation.walk.setBlendTime(0)
    animation.brag.setBlendTime(0)
    animation.interact.setBlendTime(0)
    animation.flying.setBlendTime(0)
    animation.falling.setBlendTime(0)
    animation.interact.setPriority(1)
    
    nameplate.ENTITY.setPos{0,0.5,0}
    
    emotionColor = {
        sad={
            left={0,0,0},
            right={1,1,1},
            eyebackground={0,0,0},
            eye={47.0/255,92.0/255,1},
        },
        happy={
            left={1,231/255,0},
            right={47.0/255,92.0/255,1},
            eyebackground={1,1,1},
            eye={0.1,0.1,0.1},
        }
    }
    
    for _, v in pairs(vanilla_model) do
        v.setEnabled(false)
    end
    
    for _, v in pairs(armor_model) do
        v.setEnabled(false)
    end
    
    
    isSittingDown = false
    ping.updateSit = function (state)
        isSittingDown = state
    end
    
    isDancing = false
    dance = "defaultDance"
    ping.updateDance = function (state)
        isDancing = state
    end
    
    isSad = false
    ping.updateSad = function (state)
        isSad = state
        if isSad then
            setEmotionColor("sad")
        else
            setEmotionColor("happy")
        end
    end
    
    function setEmotionColor(preset)
        model.base.waist.torso.MIMIC_HEAD.PUPIL.setColor({emotionColor[preset].eye})
        model.base.waist.torso.MIMIC_HEAD.RFACE.setColor({emotionColor[preset].right})
        model.base.waist.torso.MIMIC_HEAD.LFACE.setColor({emotionColor[preset].left})
        model.base.waist.torso.MIMIC_HEAD.EYEBACKGROUND.setColor({emotionColor[preset].eyebackground})
    end
    
    interact = keybind.getRegisteredKeybind("key.use")
    
    action_wheel.SLOT_1.setItem("oak_stairs")
    action_wheel.SLOT_1.setTitle("toggle sit down")
    action_wheel.SLOT_1.setFunction(function ()
        ping.updateSit(not isSittingDown)
    end)
    
    action_wheel.SLOT_2.setTitle("toggleEmotion")
    action_wheel.SLOT_2.setItem("white_wool")
    action_wheel.SLOT_2.setFunction(function ()
        ping.updateSad(not isSad)
    end)
    
    action_wheel.SLOT_3.setTitle("toggleDance")
    action_wheel.SLOT_3.setItem("jukebox")
    action_wheel.SLOT_3.setFunction(function ()
        ping.updateDance(not isDancing)
    end)
    
    action_wheel.SLOT_8.setItem("ender_eye")
    action_wheel.SLOT_8.setTitle("toggle camera")
    action_wheel.SLOT_8.setFunction(function ()
        actualCamPosMode = not actualCamPosMode
        if actualCamPosMode then
            camera.THIRD_PERSON.setPos({})
            camera.FIRST_PERSON.setPos({})
        end
    end)
    
    function player_init()
        setEmotionColor("happy")
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
            fragColor = color;
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
          renderlayers.registerRenderLayer("fullBrightL", {}, intro, outro)
        model.base.setRenderLayer("fullBrightL")
        --NAMEPLATE
        local playerName = player.getName()
        if playerName == "GNamimates" then
            playerName = "ENAmimates"
        end
        local nameLength = string.len(playerName)
        local nameHalfLength = math.floor(nameLength / 2)
        
        local halfOfTheName = ""
        for i = 1, nameHalfLength, 1 do
            halfOfTheName = halfOfTheName..string.sub(playerName,i,i)
        end
        local OtherhalfOfTheName = ""
        for i = nameHalfLength+1, nameLength, 1 do
            OtherhalfOfTheName = OtherhalfOfTheName..string.sub(playerName,i,i)
        end
    
        nameplate.CHAT.setText("§e"..halfOfTheName.."§9"..OtherhalfOfTheName)
        nameplate.ENTITY.setText("§e"..halfOfTheName.."§9"..OtherhalfOfTheName)
        nameplate.LIST.setText("§e"..halfOfTheName.."§9"..OtherhalfOfTheName)
    end
    
    actualCamPosMode = false
    
    
    SMTimer = 0
    SNYCTIME = 0
    
    
    function tick()
        if not actualCamPosMode then
            camera.THIRD_PERSON.setPos((model.base.EYEHEIGHT.getAnimPos()-vectors.of{0,player.getEyeHeight()*16})/vectors.of{16,16,16})
            camera.FIRST_PERSON.setPos((model.base.EYEHEIGHT.getAnimPos()-vectors.of{0,player.getEyeHeight()*16})/vectors.of{16,16,16})
        end
        
        SNYCTIME = SNYCTIME + 1
        if SNYCTIME > 5*20 then
            SNYCTIME = 0
            ping.updateSit(isSittingDown)
            ping.updateSad(isSad)
            ping.updateDance(isDancing)
        end
        if interact.isPressed() then
            animation.interact.play()
        end
        if world.getBlockState(player.getPos()+vectors.of{0,2,0}).isCollidable() or player.isSneaky() then
            setState("goDown","tooTall")
        else
            setState("goDown",nil)
        end
        if isDancing then
            setState("animation",dance)
        else
            if player.getVehicle() ~= nil then
                setState("animation","sitDownVehicle")
            else
                if player.isOnGround() then
                    if isSittingDown then
                        setState("animation","sitDown")
                    else
                        if (player.getVelocity()*vectors.of{1,0,1}).distanceTo(vectors.of{0,0,0}) > 0.03 then
                            setState("animation","walk")
                        else
                            if isSad then
                                setState("animation","brag")
                            else
                                setState("animation","idle")
                            end
                            
                        end
                    end
                else
                    if player.getVelocity().y > 0 then
                        setState("animation","flying")
                    else
                        setState("animation","falling")
                    end
                end
            end
        end
        
    
        SMTimer = SMTimer + 1
        if SMTimer > 2 then
            stateChanged("animation")
            stateChanged("goDown")
            SMTimer = 0
        end
    end
    SM_states = {current={},last={}}
    
    ---Declares the state machine and sets the state machine
    function setState(state_machine_name,state_value)
        if SM_states.last[state_machine_name] ~= state_value or SM_states.last[state_machine_name] == nil then
            SM_states.current[state_machine_name] = state_value
        end
    end
    
    queued = {}
    
    ---Returns the curent and last state in the selected state machine, in a table:  
    ---`{current,last}`
    function getState(state_machine_name)
        return {current=SM_states.current[state_machine_name],last=SM_states.last[state_machine_name]}
    end
    
    ---Returns true if the state was changed.
    function stateChanged(state_machine_name)
        local currentState = SM_states.current[state_machine_name]
        local lastState = SM_states.last[state_machine_name]
    
        local stateChanged = (lastState ~= currentState)
        -- [If you want to trigger something when the state changed, un comment the code bellow] --
        if stateChanged then
            if SM_states.last[state_machine_name] ~= nil then
                animation[SM_states.last[state_machine_name]].stop()
            end
            if SM_states.current[state_machine_name] ~= nil then
                animation[SM_states.current[state_machine_name]].play()
            end
    
            if not queued[state_machine_name] then
                queued[state_machine_name] = {}
            end
            SM_states.last[state_machine_name] = SM_states.current[state_machine_name]
            table.insert(queued[state_machine_name],SM_states.current[state_machine_name])
        end
        return stateChanged
    end
    
    