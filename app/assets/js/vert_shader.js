var vert_shader;

vert_shader = "attribute vec3 aVertexPosition;\nattribute vec4 aVertexColor;\n\nuniform mat4 uMVMatrix;\nuniform mat4 uPMatrix;\n\nvarying vec4 vColor;\n\nvoid main(void) {\n    gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);\n    vColor = aVertexColor;\n}";
