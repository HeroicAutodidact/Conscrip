var vert_shader;

vert_shader = "attribute vec3 aVertexPosition;\nattribute vec4 aVertexColor;\nattribute vec3 aVertexNormal;\n\nuniform mat4 uMVMatrix;\nuniform mat4 uPMatrix;\nuniform mat4 uNMatrix;\n\nvarying vec4 vColor;\nvarying vec4 fNormal;\n\nvoid main(void) {\n	fNormal = normalize(uNMatrix * vec4(aVertexNormal,1.0));\n	// vec3 fNormal = uNMatrix * aVertexNormal;\n    gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);\n    vColor = aVertexColor;\n    // vColor = vec4(abs(aVertexNormal.x), abs(aVertexNormal.y), abs(aVertexNormal.z), 1.0);\n}";
