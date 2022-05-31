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
    uniform mat3 MayaMatrix;
    uniform vec3 cameraPos;
    uniform float GameTime;

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

    vec2 hash( vec2 p ){
    	p = vec2( dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)) );
    	return -1.0 + 2.0*fract(sin(p)*43758.5453123);
    }

    float noise(vec2 p){
        const float K1 = 0.366025404; // (sqrt(3)-1)/2;
        const float K2 = 0.211324865; // (3-sqrt(3))/6;

    	vec2  i = floor( p + (p.x+p.y)*K1 );
        vec2  a = p - i + (i.x+i.y)*K2;
        float m = step(a.y,a.x); 
        vec2  o = vec2(m,1.0-m);
        vec2  b = a - o + K2;
    	vec2  c = a - 1.0 + 2.0*K2;
        vec3  h = max( 0.5-vec3(dot(a,a), dot(b,b), dot(c,c) ), 0.0 );
    	vec3  n = h*h*h*h*vec3( dot(a,hash(i+0.0)), dot(b,hash(i+o)), dot(c,hash(i+1.0)));
        return dot( n, vec3(70.0) );
    }

    void main() {
        vec3 V = Position.xyz * transpose(MayaMatrix);
        vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
        gl_Position = ProjMat * ModelViewMat * vec4(Position + vec3(0,noise(V.zy*(vertexDistance*0.5)+vec2(GameTime*1000))*0.1,0), 1.0);

        vertexPos = Position;
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
    in vec2 texCoord0;

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
        //vec4 worldNormal = vec4(MayaMatrix * normal.xyz ,0); //calculates actual normal
        
	    fragColor = texture(Sampler0, texCoord0)*vertexColor;

    }
  ]==]
    renderlayers.registerShader("FlagShader", format, Vert, ChromeFrag, 1, {cameraPos="vec3",MayaMatrix="mat3"})
    local chromeIntro = function()
        renderlayers.useShader("FlagShader")
        renderlayers.setTexture(0, "MY_TEXTURE")
        renderlayers.enableDepthTest()
        renderlayers.disableCull()

        local zero = vectors.worldToCameraPos({0, 0, 0})
        local x = vectors.worldToCameraPos({-1, 0, 0})-zero
        local y = vectors.worldToCameraPos({0, -1, 0})-zero
        local z = vectors.worldToCameraPos({0, 0, -1})-zero
        local matrix = {-x[1], -y[1], -z[1], -x[2], -y[2], -z[2], x[3], y[3], z[3]}
        renderlayers.setUniform("FlagShader","MayaMatrix",matrix)
        --renderlayers.setUniform("FlagShader","cameraPos",renderer.getCameraPos()-player.getPos(delt)-vectors.of{0,0.9,0})
    end
    local outro = function()
        renderlayers.restoreDefaults()
    end
    renderlayers.registerRenderLayer("FlagRenderLayer", {}, chromeIntro, outro)
    model.SKULL.cloth.setRenderLayer("FlagRenderLayer")
end