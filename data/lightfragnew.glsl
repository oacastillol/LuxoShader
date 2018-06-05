#version 150
in vec4 position,normal;
uniform mat4 projectionMatrix,modelviewMatrix;
// the key here is flat default is smooth interpolation 
flat out vec3 vN;
void main() {
    // normal matrix
mat4 nrm_Mtrx = transpose(inverse(modelviewMatrix));
    // vertex normal
vN = normalize(vec3(nrm_Mtrx*vec4(normal.xyz,0.)).xyz);
gl_Position = projectionMatrix*modelviewMatrix*position;
}