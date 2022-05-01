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
      gl_Position[0] = 1


      vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
      vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
      lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
      overlayColor = texelFetch(Sampler1, UV1, 0);
      texCoord0 = UV0;
      normal = ProjMat * ModelViewMat * vec4(UV0,0.0 , 0.0);
    }