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
uniform mat3 worldToCameraPos;
uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec4 normal;
out vec3 relativeWorldPos;
out vec3 VERTEX;


void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    VERTEX = Position;
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = Color;
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
    relativeWorldPos = worldToCameraPos*Position;
}