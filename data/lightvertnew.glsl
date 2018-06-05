#version 150
flat in vec3 vN;
uniform vec3 LDir;
uniform vec3 surfaceColor;
out vec4 fragColor;
void main() {
// simpel diffuse
float brightness = clamp( max(0., dot(vN, normalize(LDir) ) ) ,0.,1.);
fragColor.rgb = brightness * surfaceColor;
fragColor.a=1.0;
}