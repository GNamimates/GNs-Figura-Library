--[[--====================================================================---------
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
]]--======================================================================---------
for _, v in pairs(vanilla_model) do
    v.setEnabled(false)
end

for _, v in pairs(armor_model) do
    v.setEnabled(false)
end


function setupOutline(part)
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

    //This line wasn't in the template, but I added it in so I could use the GameTime in the calculation.
    uniform float GameTime;

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

    vec4 minecraft_mix_light(vec3 lightDir0, vec3 lightDir1, vec3 normal, vec4 color) {
      lightDir0 = normalize(lightDir0);
      lightDir1 = normalize(lightDir1);
      float light0 = max(0.0, dot(lightDir0, normal));
      float light1 = max(0.0, dot(lightDir1, normal));
      float lightAccum = min(1.0, (light0 + light1) * 0.6 + 0.4);
      return vec4(color.rgb * lightAccum, color.a);
    }

    void main() {
      gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
      vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
      vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
      lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
      overlayColor = texelFetch(Sampler1, UV1, 0);
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
    uniform vec4 OutlineColor;

    in float vertexDistance;
    in vec4 vertexColor;
    in vec4 lightMapColor;
    in vec4 overlayColor;
    in vec2 texCoord0;
    in vec4 normal;

    out vec4 fragColor;

    vec4 linear_fog(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
      if (vertexDistance <= fogStart) {
        return inColor;
      }

      float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
      return vec4(mix(inColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);
    }

    void main() {
      if (OutlineColor.a != 0) {
        fragColor = OutlineColor;
      } else {
        vec4 color = texture(Sampler0, texCoord0);
        if (color.a < 0.1) {
            discard;
        }
        color *= vertexColor * ColorModulator;
        color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
        color *= lightMapColor;
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
      }
    }
  ]==]
    local customUniforms = {OutlineColor = "vec4"}  
    renderlayers.registerShader("Outline Shader", format, vertexSource, fragmentSource, 3, customUniforms)
    local REDB = function()
        renderlayers.useShader("Outline Shader")
        renderlayers.enableDepthTest()
        renderlayers.enableLightmap()
        renderlayers.enableCull()
        --Change this last vector to be "r, g, b, 1" for your outline color rgb, with rgb from 0 to 1 instead of 0 to 255
        renderlayers.setUniform("Outline Shader", "OutlineColor", vectors.of({0.1, 0.1, 0.1, 1.0})) 

        renderlayers.stencilFunc(renderlayers.GL_EQUAL, 0, 255)
    end
    local BLUEB = function()
        renderlayers.useShader("Outline Shader")
        renderlayers.enableDepthTest()
        renderlayers.enableLightmap()
        renderlayers.enableCull()
        --Change this last vector to be "r, g, b, 1" for your outline color rgb, with rgb from 0 to 1 instead of 0 to 255
        renderlayers.setUniform("Outline Shader", "OutlineColor", vectors.of({0.2, 0.1, 0.1, 1.0})) 

        renderlayers.stencilFunc(renderlayers.GL_EQUAL, 0, 255)
    end
    local outlineAfter = function()
    renderlayers.stencilFunc(renderlayers.GL_ALWAYS, 0, 255)
    renderlayers.restoreDefaults()
    end
    renderlayers.registerRenderLayer("gray", {}, REDB, outlineAfter)
    renderlayers.registerRenderLayer("red", {}, BLUEB, outlineAfter)
    renderlayers.setPriority("gray", 1)

  --model.OutlineBase is a separate folder containing your entire normal model again, but with some inflate added to it.
end

nameplate.CHAT.setText("§cCUPamimates")
nameplate.LIST.setText("§cCUPamimates")
nameplate.ENTITY.setText("§cCUPamimates")

scale = 0.8
groundTime = 0

animation.idle.setSpeed(2)
animation.jump.setSpeed(2)
animation.walk.setSpeed(3)

animation.idle.setBlendTime(0.1)
animation.jump.setBlendTime(0)
animation.walk.setBlendTime(0.5)

function player_init()
    setupOutline()
    model.base.torso.waist.MIMIC_HEAD.OUTLINE1.setRenderLayer("gray")
    model.base.torso.waist.MIMIC_HEAD.straw.OUTLINE2.setRenderLayer("gray")
    model.base.torso.waist.armL.elbowL.handL.OUTLINE4.setRenderLayer("gray")
    model.base.torso.waist.armR.elbowR.handR.OUTLINE3.setRenderLayer("gray")
    model.base.legL.OUTLINE5.setRenderLayer("gray")
    model.base.legR.OUTLINE6.setRenderLayer("gray")
    model.base.legR.kneeR.bootR.OUTLINE7.setRenderLayer("red")
    model.base.legL.kneeL.bootL.OUTLINE8.setRenderLayer("red")
    model.base.legL.kneeL.outline.setRenderLayer("gray")
    model.base.legR.kneeR.outline.setRenderLayer("gray")
    model.base.torso.outline.setRenderLayer("red")
    model.base.setScale{scale,scale,scale}
    
end

function tick()
    if player.isOnGround() then
        groundTime = groundTime + 1
    else
        groundTime = 0
    end

    if groundTime > 1 then
        if (player.getVelocity()*vectors.of{1,0,1}).distanceTo(vectors.of{0,0,0}) > 0.1 then
            setState("state","walk")
        else
            setState("state","idle")
        end
    else
        setState("state","jump")
    end

    local a = stateChanged("state")
end

SM_states = {current={},last={}}

---Declares the state machine and sets the state machine
function setState(state_machine_name,state_value)
    if SM_states.last[state_machine_name] ~= state_value or SM_states.last[state_machine_name] == nil then
        SM_states.last[state_machine_name] = SM_states.current[state_machine_name]
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
        
        animation[SM_states.current[state_machine_name]].play()

        if not queued[state_machine_name] then
            queued[state_machine_name] = {}
        end
        table.insert(queued[state_machine_name],SM_states.current[state_machine_name])
    end
    return stateChanged
end

function tick()
    for key, value in pairs(queued) do
        if getLen(value) > 1 then
            if animation[value[1]].getPlayState() == "STOPPED" then
                animation[value[1]].play()
            else
                table.remove(value,1)
            end
        end
    end
end

function getLen(tab)
    local c = 0
    for _, _ in pairs(tab) do
        c = c + 1
    end
    return c
end