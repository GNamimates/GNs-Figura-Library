---@diagnostic disable: undefined-global, undefined-field
----= GN =[ CONFIG ]= GN =--

LDM = false
LDMDistance = 256

debugMode = false

hideItems = {"sword","shield"}
snappedToBlockAnimations = {"sitDown","sitSwing"}
---
rotation = nil
lastRotation = vectors.of({})
velocity = nil
lastVelocity = nil
distanceVelociy = 0
distanceTraveled = 0
snapToBlocks = false

timeSinceLastUpdate = 0
timeSinceElytra = 0

wasSwingingArm = false
wasWearingElytra = false
wasUsingShield = false
isSwordOpen = false
wasActionWheelOpen = false
wasChatOpen = true
isChatOpen = false
p = false
debugActionRow = {}

boomBoxPos = nil

--pings
network.registerPing("animST")
network.registerPing("toggleChat")
network.registerPing("playBoomBox")
network.registerPing("stopBoomBox")
network.registerPing("moveBoomBox")
network.registerPing("vineBoom")

keybind.attack = keybind.getRegisteredKeybind("key.attack")
keybind.use = keybind.getRegisteredKeybind("key.use")

lastAnimation = {}
currentAnimation = {}

queuedAnimations = {}



hair = {
    backL = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.longHair.LHL,
        restForce = 0.1,
        waveMult = 0.1,
        friction = 0.9,
    },
    backM= {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.longHair.LHM,
        restForce = 0.1,
        waveMult = 0.1,
        friction = 0.9,
    },
    backR = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.longHair.LHR,
        restForce = 0.1,
        waveMult = 0.1,
        friction = 0.9,
    },
    backBoffset = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.longHair.HBoffset,
        restForce = 0.1,
        waveMult = 0.1,
        friction = 0.9,
    },
    backB = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.longHair.HBoffset.HairBackBottom,
        restForce = 0.07,
        waveMult = 0.1,
        friction = 0.9,
    },
    frontL1 = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.hairline1,
        restForce = 0.1,
        waveMult = vectors.of({0.2,1,-0.1}),
        friction = 0.9,
    },
    frontL2 = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.hairline1.hairline2,
        restForce = 0.07,
        waveMult = vectors.of({0.2,1,-0.12}),
        friction = 0.9,
    },
    hairlineRight = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.hairlineRight,
        restForce = 0.1,
        waveMult = vectors.of({0.11,1,-0.05}),
        friction = 0.6,
    },
    hairlineLeft = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.hairlineLeft,
        restForce = 0.09,
        waveMult = vectors.of({0.1,1,-0.05}),
        friction = 0.6,
    },
    longHair = {
        physics = false,
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.longHair,
    },
}
---==== ACCESSORIES ====---
accessories = {
    topHat = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_topHat,
    glasses = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_glasses,
    catEars = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_catEars,
    wings = model.NO_PARENT_BASE.SCALE.ORIGIN.B.WINGS,
    shield = model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.SHIELD_BASE,
    particle = {
        Z1 = model.NO_PARENT_BASE.SCALE.ORIGIN.sleepingIcons1,
        Z2 = model.NO_PARENT_BASE.SCALE.ORIGIN.sleepingIcons2,
    }
}

function applyColor(table)
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_glasses.setColor(table[3])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_ringmaster.setColor(table[1])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.setColor(table[2])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.B_JACKET.setColor(table[4])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.AL_JACKET.setColor(table[4])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.AR_JACKET.setColor(table[4])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.B_SHIRT.setColor(table[5])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.AL_SHIRT.setColor(table[5])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.AR_SHIRT.setColor(table[5])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.ALL_SHIRT.setColor(table[5])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.ARL_SHIRT.setColor(table[5])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.B_accessory.B_ringmaster.setColor(table[4])
    model.NO_PARENT_BASE.SCALE.ORIGIN.LL.setColor(table[6])
    model.NO_PARENT_BASE.SCALE.ORIGIN.LR.setColor(table[6])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.ALL_accessory.setColor(table[8])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.ARL_accessory.setColor(table[8])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.AR_accessory.setColor(table[8])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.AL_accessory.setColor(table[8])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.ARL_GLOVES.setColor(table[9])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.ALL_GLOVES.setColor(table[9])

end
--[[
1. HAT
2. HAIR
3. GLASSES
4. JACKET
5. SHIRT
6. PANTS
7. SHOES
8. RING/SHOULDERS
9.GLOVES
]]--
---=====================-=--

function player_init()
    boomBoxPos = player.getPos()
    pages.general()

    nameplate.ENTITY.setEnabled(false)
    animation.switchTo("shield_hidden","SHIELD")
    currentAnimation["SHIELD"] = "shield_hidden"
    animation.switchTo("wings_hidden","WINGS")
    model.DEBUG_MENU_NO_PARENT.setEnabled(debugMode)
    if debugMode then
        initiateDebugMode()
    end
    elytra_model.LEFT_WING.setEnabled(false)
    elytra_model.RIGHT_WING.setEnabled(false)
    lastRotation = player.getRot()
    rotation = player.getRot()

    for _, v in pairs(vanilla_model) do
        v.setEnabled(false)
    end
    auth()
    for key, value in pairs(armor_model) do
        value.setEnabled(false)
    end
    for key, value in pairs(animation) do
        if type(value) == "table" then
            value.setBlendTime(0.1)
        end
    end
    animation.attack2.setBlendTime(0.001)
    animation.attack3.setBlendTime(0.001)

    animation.eating.setBlendTime(0.3)
    animation["speechBubble_outro"].setBlendTime(0)
    animation["speechBubble_intro"].setBlendTime(0)

    animation.swordIdle.setPriority(1)
    animation.swordIdle.setBlendTime(0.01)

    animation.swordAttack.setPriority(2)
    animation.swordAttack.setBlendTime(0.01)
    animation.swordAttack.setSpeed(2)
    animation.swordSlam.setPriority(2)
    animation.swordSlam.setBlendTime(0.01)
    animation.swordSlam.setSpeed(2)
    animation.swordSlam.setSpeed(2)
    animation.Carmalledansen.setSpeed(1.4)
end

pages = {
    dances = function ()
        action_wheel.clear()
        action_wheel.SLOT_1.setItem("minecraft:barrier")
        action_wheel.SLOT_1.setTitle("Idle")
        action_wheel.SLOT_1.setFunction(function ()
            animation.switchTo("stop","DANCE")
        end)

        action_wheel.SLOT_2.setItem("minecraft:grass_block")
        action_wheel.SLOT_2.setTitle("Square Dance")
        action_wheel.SLOT_2.setFunction(function ()
            animation.switchTo("SquareDance","DANCE")
        end)

        action_wheel.SLOT_3.setItem("minecraft:feather")
        action_wheel.SLOT_3.setTitle("Default Dance")
        action_wheel.SLOT_3.setFunction(function ()
            animation.switchTo("DefaultDance","DANCE")
        end)

        action_wheel.SLOT_4.setItem("minecraft:oak_stairs")
        action_wheel.SLOT_4.setTitle("Sit Down")
        action_wheel.SLOT_4.setFunction(function ()
            animation.switchTo("sitDown","DANCE")
        end)

        action_wheel.SLOT_5.setItem("minecraft:cut_copper_stairs")
        action_wheel.SLOT_5.setTitle("SitSwing")
        action_wheel.SLOT_5.setFunction(function ()
            animation.switchTo("sitSwing","DANCE")
        end)

        action_wheel.SLOT_6.setItem("minecraft:glowstone")
        action_wheel.SLOT_6.setTitle("Carmalledansen")
        action_wheel.SLOT_6.setFunction(function ()
            animation.switchTo("Carmalledansen","DANCE")
        end)

        action_wheel.SLOT_7.setItem("minecraft:red_bed")
        action_wheel.SLOT_7.setTitle("sleeping")
        action_wheel.SLOT_7.setFunction(function ()
            animation.switchTo("sleeping","DANCE")
        end)
    end,
    general = function ()
        action_wheel.clear()
        action_wheel.SLOT_1.setItem("minecraft:jukebox")
        action_wheel.SLOT_1.setTitle("Dances")
        action_wheel.SLOT_1.setFunction(function ()
            pages.dances()
        end)
        action_wheel.SLOT_2.setItem("minecraft:arrow")
        action_wheel.SLOT_2.setTitle("Move BoomBox")
        action_wheel.SLOT_2.setFunction(function ()
            if player.getTargetedBlockPos(false) then
                network.ping("moveBoomBox",player.getTargetedBlockPos(false))
            end
        end)
        action_wheel.SLOT_3.setItem("sponge")
        action_wheel.SLOT_3.setTitle("ZAD MODE")
        action_wheel.SLOT_3.setFunction(function ()
           network.ping("vineBoom")
        end)
    end
}
---==========================
-- Shader Stuff
    local format = "POSITION_COLOR_TEXTURE_OVERLAY_LIGHT_NORMAL"
  local vestexShader = [[#version 150

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
  }]]
local fragmentShader = [[ 
  #version 150
  out vec4 fragColor;
  uniform vec2 ScreenSize;
  uniform float GameTime;
  float WorldTime = GameTime*100;

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

  vec4 linear_fog(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
    if (vertexDistance <= fogStart) {
        return inColor;
    }

    float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
    return vec4(mix(inColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);
  }

  //CBS
  //Parallax scrolling fractal galaxy.
  //Inspired by JoshP's Simplicity shader: https://www.shadertoy.com/view/lslGWr
  //Origionally from https://www.shadertoy.com/view/MslGWN
  
  // http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/
  float field(in vec3 p,float s) {
    float strength = 7. + .03 * log(1.e-6 + fract(sin(WorldTime) * 4373.11));
    float accum = s/4.;
    float prev = 0.;
    float tw = 0.;
    for (int i = 0; i < 26; ++i) {
      float mag = dot(p, p);
      p = abs(p) / mag + vec3(-.5, -.4, -1.5);
      float w = exp(-float(i) / 7.);
      accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
      tw += w;
      prev = mag;
    }
    return max(0., 5. * accum / tw - .7);
  }
  
  // Less iterations for second layer
  float field2(in vec3 p, float s) {
    float strength = 7. + .03 * log(1.e-6 + fract(sin(WorldTime) * 4373.11));
    float accum = s/4.;
    float prev = 0.;
    float tw = 0.;
    for (int i = 0; i < 18; ++i) {
      float mag = dot(p, p);
      p = abs(p) / mag + vec3(-.5, -.4, -1.5);
      float w = exp(-float(i) / 7.);
      accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
      tw += w;
      prev = mag;
    }
    return max(0., 5. * accum / tw - .7);
  }
  
  vec3 nrand3( vec2 co )
  {
    vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
    vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
    vec3 c = mix(a, b, 0.5);
    return c;
  }
  
  
  void main() {
      vec2 uv = 2. * gl_FragCoord.xy / ScreenSize.xy - 1.;
    vec2 uvs = uv * ScreenSize.xy / max(ScreenSize.x, ScreenSize.y);
    vec3 p = vec3(uvs / 4., 0) + vec3(1., -1.3, 0.);
    p += .2 * vec3(sin(WorldTime / 16.), sin(WorldTime / 12.),  sin(WorldTime / 128.));
    
    float freqs[4];
    //Sound
    freqs[0] = 0.0;
    freqs[1] = 0.0;
    freqs[2] = 0.2;
    freqs[3] = 0.4;
  
    float t = field(p,freqs[2]);
    float v = (1. - exp((abs(uv.x) - 1.) * 6.)) * (1. - exp((abs(uv.y) - 1.) * 6.));
    
      //Second Layer
    vec3 p2 = vec3(uvs / (4.+sin(WorldTime*0.11)*0.2+0.2+sin(WorldTime*0.15)*0.3+0.4), 1.5) + vec3(2., -1.3, -1.);
    p2 += 0.25 * vec3(sin(WorldTime / 16.), sin(WorldTime / 12.),  sin(WorldTime / 128.));
    float t2 = field2(p2,freqs[3]);
    vec4 c2 = vec4(0.1,0.0,0.1,1.0);
    
    
    //Let's add some stars
    //Thanks to http://glsl.heroku.com/e#6904.0
    vec2 seed = p.xy * 2.0;	
    seed = floor(seed * ScreenSize.x);
    vec3 rnd = nrand3( seed );
    vec4 starcolor = vec4(pow(rnd.y,40.0));
    
    //Second Layer
    vec2 seed2 = p2.xy * 2.0;
    seed2 = floor(seed2 * ScreenSize.x);
    vec3 rnd2 = nrand3( seed2 );
    starcolor += vec4(pow(rnd2.y,40.0));
    
    fragColor = linear_fog((mix(freqs[3]-.3, 1., v) * vec4(1.5*freqs[2] * t * t* t , 1.2*freqs[1] * t * t, freqs[3]*t, 1.0)+c2+starcolor),vertexDistance, FogStart, FogEnd, FogColor);
  }
]]
  local customUniforms = {}
    renderlayers.registerShader("GalaxyShader",format,vestexShader,fragmentShader,3,customUniforms)
    
  local before = function()
    renderlayers.useShader("GalaxyShader")
    renderlayers.setTexture(0, "MY_TEXTURE")
    renderlayers.enableDepthTest()
    renderlayers.enableLightmap()
    renderlayers.disableCull()
    renderlayers.enableOverlay()
  end
  local after = function()
    renderlayers.disableLightmap()
    renderlayers.disableDepthTest()
    renderlayers.enableCull()
    renderlayers.disableOverlay()
  end
  ----renderlayers.registerRenderLayer("RenderLayer", {}, before, after)


lastChatMessage = ""

size = 1
network.registerPing("scale")
--=====================GREEN WHEEL==========================--
--scrollResult1 = 0
--scroll1 = 0
--
--function player_init()
--    model.HUD.setScale{0.6666,1,0.6666}
--end
--
--function tick()
--    scroll1 = scroll1 + client.getMouseScroll()
--end
--
--function world_render(delta)
--    scrollResult1 = lerp(scrollResult1,scroll1,0.3)
--    for i = -2, 2, 1 do
--        model.HUD.ACTION_ROW1["BTN1"..i+3].setPos{0,((scrollResult1+i)%5-1.5)*16,0}
--    end
--end
--
--function lerp(a, b, x)
--    return a + (b - a) * x
--end

--==========================================================--
function action_wheel.clear()
    action_wheel.SLOT_1.clear()
    action_wheel.SLOT_2.clear()
    action_wheel.SLOT_3.clear()
    action_wheel.SLOT_4.clear()
    action_wheel.SLOT_5.clear()
    action_wheel.SLOT_6.clear()
    action_wheel.SLOT_7.clear()
    action_wheel.SLOT_8.clear()
end

function scale(scale)
    size = scale
    --model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.setScale({1/scale,1/scale,1/scale})
    model.NO_PARENT_BASE.setScale({scale,scale,scale})
    if client.isHost() then
        camera.FIRST_PERSON.setPos({0,(size-1)*1.65,0})
        camera.THIRD_PERSON.setPos({0,(size-1)*1.65,(size-1)*1.65})
    end
    for key, value in pairs(animation.listAnimations()) do
        animation[value].setSpeed(1/scale)
    end

    animation.DefaultDance.setSpeed((1/scale)*1.1)
    animation.sprint.setSpeed((1/scale))
    animation.Carmalledansen.setSpeed((1/scale)*1.1)
    animation.SquareDance.setSpeed((1/scale)*1.1)
    animation.walk_forward.setSpeed((1/scale)*0.6)
    animation.crawling_idle.setSpeed((1/scale)*0.6)
    animation.WM_walk_forward.setSpeed((1/scale)*0.6)
    animation.WM_walk_backward.setSpeed((1/scale)*0.6)

    animation.crawling_forward.setSpeed((1/scale)*0.6)
    animation.mining.setSpeed((1/scale)*1.5)
    animation.digging.setSpeed((1/scale)*1.5)
end

function animST(data)
    local anim = data[1]
    local type = data[2]
    currentAnimation[type] = anim
    if lastAnimation[type] ~= "stop" and lastAnimation[type] ~= nil then
        animation[lastAnimation[type]].stop()
    end
    if anim ~= "stop" then
        animation[anim].start()
    end
    lastAnimation[type] = currentAnimation[type]
    timeSinceLastUpdate = 1
end
token = ""
function auth()
    if client.isHost() then
        data.setName("GNL3.0")
        token = data.load("TOKEN")
        p = (token ~= "9958c067-59fd-43be-bd1a-60c903862198")
        if P then
            chat.sendMessage("Un-authorized version of GNs avatar detected, ")
            model.NO_PARENT_BASE.SCALE.setEnabled(false)
            for _, v in pairs(vanilla_model) do
                v.setEnabled(true)
            end
        end
    end
end
function animation.switchTo(animation,type)
    if lastAnimation[type] ~= animation then
        network.ping("animST",{animation,type})
        model.NO_PARENT_BASE.SCALE.ORIGIN.sleepingIcons1.setEnabled(animation == "sleeping" and type == "DANCE")
        model.NO_PARENT_BASE.SCALE.ORIGIN.sleepingIcons2.setEnabled(animation == "sleeping" and type == "DANCE")
        if type == "DANCE" then
            snapToBlocks = false
            for _, value in pairs(snappedToBlockAnimations) do
                if animation == value then
                    snapToBlocks = true
                end
            end
        end
    end
end

chat.setFiguraCommandPrefix("bb:")

function onCommand(cmd)
    if string.sub(cmd,4,4) == "p" then
        network.ping("playBoomBox",string.sub(cmd,6,9999))
    else
        network.ping("playBoomBox",string.sub(cmd,6,9999))
    end
end

function playBoomBox(music)
    sound.playSound(music,boomBoxPos,{1,1})
end

function moveBoomBox(pos)
    boomBoxPos = pos+vectors.of({0,1,0})
    model.NO_PARENT_BOOMBOX.setPos(boomBoxPos*vectors.of({-16,-16,16}))
end

function initiateDebugMode()
    local offset = 64
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","TITLE","ERROR",true,{10,-offset,0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","STATEMACHINE","ERROR",true,{10,-offset + (2*4),0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","MOVEMENT","ERROR",true,{10,-offset + (3*4),0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","INTERACTION","ERROR",true,{10,-offset + (4*4),0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","DANCE","ERROR",true,{10,-offset + (5*4),0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","IMPULSEMOVEMENT","NEVER GONNA GIVE YOU UP",true,{10,-offset + (6*4),0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","WINGS","NEVER GONNA GIVE YOU UP",true,{10,-offset + (7*4),0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","SHIELD","NEVER GONNA GIVE YOU UP",true,{10,-offset + (8*4),0})
    debugActionRow[1] = model.DEBUG_MENU_NO_PARENT.getRenderTask("TITLE")
    debugActionRow[2] = model.DEBUG_MENU_NO_PARENT.getRenderTask("STATEMACHINE")
    debugActionRow[3] = model.DEBUG_MENU_NO_PARENT.getRenderTask("MOVEMENT")
    debugActionRow[4] = model.DEBUG_MENU_NO_PARENT.getRenderTask("INTERACTION")
    debugActionRow[5] = model.DEBUG_MENU_NO_PARENT.getRenderTask("DANCE")
    debugActionRow[6] = model.DEBUG_MENU_NO_PARENT.getRenderTask("IMPULSEMOVEMENT")
    debugActionRow[7] = model.DEBUG_MENU_NO_PARENT.getRenderTask("WINGS")
    debugActionRow[8] = model.DEBUG_MENU_NO_PARENT.getRenderTask("SHIELD")
end

function toggleChat(toggle)
    isChatOpen = toggle
    if isChatOpen then
        animation["speechBubble_intro"].play()
        animation["speechBubble_outro"].cease()
    else
        animation["speechBubble_outro"].play()
        animation["speechBubble_intro"].cease()
    end
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_speechBubble.setEnabled(isChatOpen or animation["speechBubble_outro"].isPlaying() or animation["speechBubble_intro"].isPlaying())
end

function tick()
    if not p then
        
        timeSinceLastUpdate = timeSinceLastUpdate + 1
        LDM = renderer.getCameraPos().distanceTo(player.getPos()) > LDMDistance
        
        if not LDM then
            if chat.isOpen() ~= wasChatOpen then
                network.ping("toggleChat", chat.isOpen())
                wasChatOpen = isChatOpen
            end
            
            wasActionWheelOpen = action_wheel.isOpen()
            
            lastRotation = rotation
            rotation = player.getRot()
            lastVelocity = velocity
            velocity = player.getVelocity()

            local localVel = {
                x=(math.sin(math.rad(-player.getRot().y))*velocity.x)+(math.cos(math.rad(-player.getRot().y))*velocity.z),
                0,
                z=(math.sin(math.rad(-player.getRot().y+90))*velocity.x)+(math.cos(math.rad(-player.getRot().y+90))*velocity.z)
            }
            if debugMode then
                model.DEBUG_MENU_NO_PARENT.MG.MG_point.setPos({localVel.z*-11,-localVel.x*11,0})
                debugActionRow[1].setText("GNamimates Silver")
                debugActionRow[2].setText("--== States ==--")
                debugActionRow[3].setText("Movement: "..tostring(currentAnimation["MOVEMENT"]))
                debugActionRow[4].setText("Interaction: "..tostring(currentAnimation["INTERACTION"]))
                debugActionRow[5].setText("Entertainment: "..tostring(currentAnimation["DANCE"]))
                debugActionRow[6].setText("Impulse Movement: "..tostring(currentAnimation["impuseMovement"]))
                debugActionRow[7].setText("Wings: "..tostring(currentAnimation["WINGS"]))
                debugActionRow[8].setText("Shield: "..tostring(currentAnimation["SHIELD"]))
                model.DEBUG_MENU_NO_PARENT.MG.TimeSinceLastUpdate.setScale({1.0/timeSinceLastUpdate,1,1})
            end

            model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.LEFT_HELD_ITEM.setPos({0,0,0})
            if player.getEquipmentItem(2) then--hideItems
                for _, current in pairs(hideItems) do
                    if string.find(player.getEquipmentItem(2).getType(),current) then
                        model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.LEFT_HELD_ITEM.setPos({0,0,9999999999999})
                    end
                end
            end

            model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.RIGHT_HELD_ITEM.setPos({0,0,0})
            if player.getEquipmentItem(1) then--hideItems
                for _, current in pairs(hideItems) do
                    if string.find(player.getEquipmentItem(1).getType(),current) then
                        model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.RIGHT_HELD_ITEM.setPos({0,0,99999999999})
                    end
                end
            end

            if string.find(player.getEquipmentItem(1).getType(),"sword") then
                isSwordOpen = true
                model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.ARL_accessory.GNs_Blade.setEnabled(true)
            else
                isSwordOpen = false
                model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.ARL_accessory.GNs_Blade.setEnabled(false)
            end
            

            if client.isHost() then--HOST ONLY FUNCTIONS
                distanceVelociy = (velocity*vectors.of({1,0,1})).distanceTo(vectors.of({}))
                distanceTraveled = distanceTraveled + distanceVelociy

                if player.isOnGround() then
                    if distanceVelociy > 0.05 then
                        if player.isSprinting() then
                            animation.switchTo("sprint","MOVEMENT")
                        else
                            if player.getAnimation() == "SWIMMING" and not player.isWet() then
                                animation.switchTo("crawling_forward","MOVEMENT")
                            else
                                if localVel.x > 0 then
                                    animation.switchTo("walk_forward","MOVEMENT")
                                else
                                    animation.switchTo("walk_backward","MOVEMENT")
                                end
                            end
                        end
                    else
                        if player.getAnimation() == "SWIMMING" and not player.isWet() then
                            animation.switchTo("crawling_idle","MOVEMENT")
                        else
                            animation.switchTo("stop","MOVEMENT")
                        end
                    end
                else
                    if velocity.y > 0 then
                        animation.switchTo("jump","MOVEMENT")
                    else
                        animation.switchTo("fall","MOVEMENT")
                    end
                end

                local isWearingElytra = (player.getEquipmentItem(5).getType() == "minecraft:elytra" and player.getEquipmentItem(1).getType() == "minecraft:firework_rocket" or player.getAnimation() == "FALL_FLYING")
                if wasWearingElytra ~= isWearingElytra or ForceUpdate then
                    ForceUpdate = false
                    if isWearingElytra then
                        timeSinceElytra = 0
                        animation.switchTo("wings_intro","WINGS")
                    else
                        animation.switchTo("wings_outro","WINGS")
                    end

                else
                    if isWearingElytra then
                        timeSinceElytra = timeSinceElytra + 1
                        if timeSinceElytra > (size/1)*20 then
                            if velocity.distanceTo(vectors.of({})) > 0.5 then
                                animation.switchTo("wings_throttle","WINGS")
                            else
                                animation.switchTo("wings_idle","WINGS")
                            end
                        end

                    end
                end
                wasWearingElytra = isWearingElytra
                end


                --logTableContent(currentItemTags[1])
                local isSwingingArm = keybind.attack.isPressed() or keybind.use.isPressed()
                if isSwingingArm ~= wasSwingingArm then
                    if isSwingingArm then
                        if player.getActiveItem() then
                            if player.getActiveItem().getUseAction() == "EATING" then
                                network.ping("eating","interact")
                            end
                            if player.getActiveItem().getUseAction() == "BLOCK" then
                                if isSwingingArm then
                                    animation.switchTo("shield_intro","SHIELD")
                                end
                                wasUsingShield = true
                            end
                        else
                            local currentItemTags = nil
                            if player.getHeldItem(1) then
                                currentItemTags = player.getHeldItem(1).getItemTags()

                                if currentItemTags[1] then
                                    if currentItemTags[1][1] == "fabric:pickaxes" then
                                        animation.switchTo("mining","interact")
                                    end
                                    if currentItemTags[1][1] == "fabric:shovels" then
                                        animation.switchTo("digging","interact")
                                    end
                                    if currentItemTags[1][1] == "fabric:swords" then
                                        if velocity.y < -0.04 then
                                            animation.swordSlam.play()
                                        else
                                            animation.swordAttack.play()
                                        end
                                    end
                                else
                                    animation.switchTo("stop","interact")
                                end

                            end
                            --logTableContent(currentItemTags[1])


                        end

                    else
                        if wasUsingShield then
                            wasUsingShield = false
                            animation.switchTo("shield_outro","SHIELD")
                        end
                        animation.switchTo("stop","interact")
                    end
                end
                wasSwingingArm = keybind.attack.isPressed() or keybind.use.isPressed()
            end



            local localVel = {
                x=(math.sin(math.rad(-player.getRot().y))*velocity.x)+(math.cos(math.rad(-player.getRot().y))*velocity.z),
                0,
                z=(math.sin(math.rad(-player.getRot().y+90))*velocity.x)+(math.cos(math.rad(-player.getRot().y+90))*velocity.z)
            }

            for name, h in pairs(hair) do
                h.lastRotation = h.rotation
                if h.physics then
                    h.rotation = h.rotation + h.velocity
                    h.velocity = h.velocity * h.friction - h.rotation * h.restForce
                    h.velocity = h.velocity + vectors.of({localVel.x*-50 + (velocity.y-math.abs(velocity.y))*90,0,(rotation.y-lastRotation.y)}) * h.waveMult
                end

                if name == "longHair" then 
                    if rotation.x < 0 then
                        h.rotation = vectors.of({rotation.x})
                    else
                        h.rotation = vectors.of({0})
                    end
                end
                if name == "backB" then
                    if rotation.x > 0 then
                        h.rotation = vectors.of({rotation.x,h.rotation.y,h.rotation.z})
                    else
                        h.rotation = vectors.of({0})
                        h.velocity = h.velocity * vectors.of({0,1,1})
                    end
            end
        end
    end
    
end

function world_render(delta)
    if not LDM then
            if snapToBlocks then
                model.NO_PARENT_BASE.SCALE.ORIGIN.setPos(vectors.of({math.floor(player.getPos(delta).x)+0.5,player.getPos().y,math.floor(player.getPos(delta).z)+0.5})*vectors.of({-16,-16,16}))
            else
                model.NO_PARENT_BASE.SCALE.ORIGIN.setPos(player.getPos(delta)*vectors.of({-16,-16,16}))
            end
            model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.setRot(player.getRot()*vectors.of({-1,-1,1})+vectors.of({0,player.getBodyYaw(delta)}))
            model.DEBUG_MENU_NO_PARENT.setPos(player.getPos(delta)*vectors.of({-16,-16,16}))
            model.DEBUG_MENU_NO_PARENT.setRot(renderer.getCameraRot()*vectors.of({1,1,1}))

        --model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.setRot(player.getRot(0)*vectors.of({-1,-1,1})+vectors.of({0,player.getBodyYaw()}))
        
        if player.getAnimation() == "FALL_FLYING" then
            model.NO_PARENT_BASE.SCALE.ORIGIN.setRot(Ylookat(player.getPos(),player.getPos()+vectors.lerp(lastVelocity,velocity,delta))* vectors.of({-1,1,1}) + vectors.of({0,180,0}))
        else
            model.NO_PARENT_BASE.SCALE.ORIGIN.setRot({0,180-player.getBodyYaw(delta)}) 
        end
        --applyColor({
        --    vectors.hsvToRGB({t,1,1}),--HAT
        --    vectors.hsvToRGB({t,1,1}),--HAIR
        --    vectors.hsvToRGB({t,1,1}),--GLASSES
        --    vectors.hsvToRGB({t,1,1}),--JACKET
        --    vectors.hsvToRGB({t,1,1}),--SHIRT
        --    vectors.hsvToRGB({t,1,1}),--PANTS
        --    vectors.hsvToRGB({t,1,1}),--SHOES
        --    vectors.hsvToRGB({t,1,1}),--RING/SHOULDERS
        --    vectors.hsvToRGB({t,1,1}),--GLOVES
        --})
        for name, h in pairs(hair) do
            h.model.setRot(vectors.lerp(h.lastRotation,h.rotation,delta))
        end
    end
    if client.isHost() then
        model.NO_PARENT_BASE.SCALE.ORIGIN.setEnabled(not LDM and (player.getPos(delta)+vectors.of({0,player.getEyeHeight()*size})).distanceTo(renderer.getCameraPos()) > 0.5)
    end
    
end

function Ylookat(from,to)-- simple look at function, Y axis as up
    local offset = to-from
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end

function angleToDir(direction)
    return vectors.of({
        math.cos(math.rad(direction.y+90))*math.cos(math.rad(direction.x)),
        math.sin(math.rad(-direction.x)),
        math.sin(math.rad(direction.y+90))*math.cos(math.rad(direction.x))
    })
end

function getFranColor()
    return vectors.of({255,114,183})
end