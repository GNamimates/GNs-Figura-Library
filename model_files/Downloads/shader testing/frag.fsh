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