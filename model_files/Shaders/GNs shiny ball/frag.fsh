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
    in vec2 UV;
    in vec4 NORMAL;
    in vec3 relativeWorldPos;

    out vec4 fragColor;

    void main() {
        //vec4 color = texture(Sampler0, normal.rg+UV);
        //fragColor = vec4(relativeWorldPos.xyz,2.0);

        vec3 worldNormal = mat3(CAMERA_MATRIX) * NORMAL;
	    //fragColor = texture(Sampler0,toAngle(worldNormal).xy).rgb;
	    vec3 V = normalize(camera_pos.xyz*2. - VERTEX);
	    vec3 reflection = reflect(V, worldNormal);
	    fragColor = texture(Sampler0,toAngle(reflection)).rgb;
	    //fragColor = vec3(toAngle(worldNormal).xy/PI,0);
	    //fragColor = worldNormal;
    }