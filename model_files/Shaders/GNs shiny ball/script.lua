--[[--====================================================================---------
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
--=================================================================================--
CREDITS:
Maya/devnull  -   for the camera matrix
My pet dog    -   she is cute and fluffy, I want to credit her
applejuice    -   for the shadow idea, it made the ball look better

--===================================================================================--]]

delt = 0
shadowDist = 0

function player_init()
    local format = "POSITION_COLOR_TEXTURE_OVERLAY_LIGHT_NORMAL"
    local Vert = [==[
    #version 150

    in vec3 Position;
    in vec4 Color;
    in vec2 UV0;
    in ivec2 UV1;
    in ivec2 UV2;
    in vec3 Normal;
    
    uniform mat4 ModelViewMat;
    uniform mat4 ProjMat;
    uniform mat3 worldToCameraPos;

    uniform vec3 Light0_Direction;
    uniform vec3 Light1_Direction;

    uniform sampler2D Sampler0; //Overlay Sampler
    uniform sampler2D Sampler2; //Lightmap Sampler


    out float vertexDistance;
    out vec4 vertexColor;
    out vec4 lightMapColor;
    out vec4 overlayColor;
    out vec2 texCoord0;
    out vec3 normal;
    out vec3 relativeWorldPos;
    out vec3 vertexPos;

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

      vertexPos = Position;
      vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
      vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);

      lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
      overlayColor = texelFetch(Sampler0, UV1, 0);

      texCoord0 = UV0;
      normal = Normal;
    }
  ]==]
  local ChromeFrag = [==[
    #version 150

    uniform sampler2D Sampler0;

    uniform vec3 cameraPos;
    uniform float Shininess;
    uniform mat3 MayaMatrix;

    in vec4 vertexColor;
    in vec3 normal;
    in vec3 vertexPos;

    out vec4 fragColor;

    const float PI = 3.14159;
    const float TAU = 6.28;

    vec2 toAngle(vec3 pos) {
        float x = atan(pos.z,pos.x)/ TAU + 0.5;
        float y = pos.y * 0.5 + 0.5;
        return vec2(x,y);
    }

    vec3 refl(vec3 I, vec3 N) {
        return vec3(I - 2.0 * dot(N, I) * N);
    }
    
    void main() {
        vec3 V = normalize(vertexPos * transpose(MayaMatrix));
        ////vec3 FakeNormal = vertexPos * transpose(MayaMatrix) + cameraPos; //calculates sphere normals
        vec4 worldNormal = vec4(MayaMatrix * normal.xyz ,0); //calculates actual normal
	    vec3 reflection = refl(-V, worldNormal.xyz);
        float frensel = (length(worldNormal.xyz-V)-1.8)*-2;
        
	    //fragColor = vec4(texture(Sampler0,toAngle(reflection)).rgb,1);
        fragColor = vec4(frensel);
    }
  ]==]
  local SoftShadowFrag = [==[
    #version 150

    uniform sampler2D Sampler0;
    uniform float shadowOpacity;
    uniform vec2 ScreenSize;

    in vec2 texCoord0;

    out vec4 fragColor;
    
    void main() {
        fragColor = mix(vec4(0,0,0,1), texture(Sampler0,gl_FragCoord.xy/ScreenSize), min(length(texCoord0-vec2(0.5,0.5))*2-shadowOpacity,1));
    }
  ]==]
    renderlayers.registerShader("ChromeShader", format, Vert, ChromeFrag, 1, {cameraPos="vec3",MayaMatrix="mat3"})
    renderlayers.registerShader("SoftShadowShader", format, Vert, SoftShadowFrag, 1, {shadowOpacity="float"})
    local chromeIntro = function()
        renderlayers.useShader("ChromeShader")
        renderlayers.setTexture(0, "MY_TEXTURE")
        renderlayers.enableDepthTest()
        renderlayers.enableCull()

        local zero = vectors.worldToCameraPos({0, 0, 0})
        local x = vectors.worldToCameraPos({-1, 0, 0})-zero
        local y = vectors.worldToCameraPos({0, -1, 0})-zero
        local z = vectors.worldToCameraPos({0, 0, -1})-zero
        local matrix = {-x[1], -y[1], -z[1], -x[2], -y[2], -z[2], x[3], y[3], z[3]}
        renderlayers.setUniform("ChromeShader","MayaMatrix",matrix)
        --renderlayers.setUniform("ChromeShader","cameraPos",renderer.getCameraPos()-player.getPos(delt)-vectors.of{0,0.9,0})
    end
    local shoftShadowIntro = function()
        renderlayers.useShader("SoftShadowShader")
        renderlayers.setTexture(0,"MAIN_FRAMEBUFFER")
        renderlayers.enableDepthTest()
        renderlayers.disableCull()
        renderlayers.setUniform("SoftShadowShader","shadowOpacity",shadowDist-1)
    end
    local outro = function()
        renderlayers.restoreDefaults()
    end
    renderlayers.registerRenderLayer("ChromeRenderLayer", {}, chromeIntro, outro)
    renderlayers.registerRenderLayer("SoftShadowRenderLayer", {}, shoftShadowIntro, outro)

    model.ball.setRenderLayer("ChromeRenderLayer")
    model.NO_PARENT_SHADOW.setRenderLayer("SoftShadowRenderLayer")
    
    for key, value in pairs(vanilla_model) do
        value.setEnabled(false)
    end
end

function world_render(delta)
    delt = delta
    local ray = renderer.raycastBlocks(player.getPos(delta)+vectors.of{0,1,0}, player.getPos(delt)+vectors.of{0,-4,0},"VISUAL","ANY")
    
    if ray then
        model.NO_PARENT_SHADOW.setEnabled(true)
        model.NO_PARENT_SHADOW.setPos(ray.pos*vectors.of{-16,-16,16})
        shadowDist = math.clamp((ray.pos.y-player.getPos(delta).y)*0.9+1,0,1)
    else
        model.NO_PARENT_SHADOW.setEnabled(false)
    end
end