attribute vec3 aVertexPosition;
attribute vec4 aVertexColor;
attribute vec3 aVertexNormal;

uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;
uniform mat4 uNMatrix;

varying vec4 vColor;
varying vec4 fNormal;

void main(void) {
	fNormal = normalize(uNMatrix * vec4(aVertexNormal,1.0));
	// vec3 fNormal = uNMatrix * aVertexNormal;
    gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
    vColor = aVertexColor;
    // vColor = vec4(abs(aVertexNormal.x), abs(aVertexNormal.y), abs(aVertexNormal.z), 1.0);
}