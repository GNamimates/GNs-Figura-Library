-- disable everything inside arg (table)
function disableStuff(arg)
  for key, value in pairs(arg) do
    value.setEnabled(false)
  end
end

function player_init()
  -- disable vanilla parts
  disableStuff(vanilla_model)

  
  --Custom shader stuff!
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

      //Line from the template is here:
      //gl_Position.x += 0.1*sin(gl_Position.y*5);

      //This didn't fit in to the guide, but I made a slight modification here:
      //Now the sin function uses GameTime (notice how I declared it above)
      //To make the wiggle change over time!


      vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
      vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
      lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
      overlayColor = texelFetch(Sampler1, UV1, 0);

      gl_Position.xy = gl_Position.xy * vertexDistance *1;

      texCoord0 = UV0;
      normal = ProjMat * ModelViewMat * vec4(UV0,0.0 , 0.0);
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

    vec4 linear_fog(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
      if (vertexDistance <= fogStart) {
        return inColor;
      }

      float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
      return vec4(mix(inColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);
    }

    void main() {
      vec4 color = texture(Sampler0, texCoord0);
      if (color.a < 0.1) {
          discard;
      }
      color *= vertexColor * ColorModulator;
      color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
      color *= lightMapColor;
      fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);

      //Just added these 2 lines:
      float average = (fragColor.r + fragColor.g + fragColor.b) / 3.0;
      fragColor = vec4(average, average, average, fragColor.a);
    }
  ]==]
  --Register the shader:
  renderlayers.registerShader("My Shader", format, vertexSource, fragmentSource, 3, nil)

  local before = function()
    renderlayers.useShader("My Shader")
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
  --Register the render layer:
  renderlayers.registerRenderLayer("My Render Layer", {}, before, after)

  --Finally, set the render layer on whatever part you want!
  --I'm using model.Base, which in this avatar contains everything else.
  model.Base.setRenderLayer("My Render Layer")
end