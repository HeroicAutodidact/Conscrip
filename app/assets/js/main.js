var camMatrix, camera, clearScreen, createColorBuffer, createVertexBuffer, degToRad, drawScene, gl, initBuffers, initDrawingConfigs, initGL, initShaders, lastTime, m4, mvMatrix, mvMatrixStack, nMatrix, pMatrix, rSquare, rTri, setMatrixUniforms, shaderProgram, squareVertexColorBuffer, squareVertexNormalBuffer, squareVertexPositionBuffer, tick, triangleVertexColorBuffer, triangleVertexPositionBuffer, update, webGLStart;

gl = shaderProgram = triangleVertexPositionBuffer = triangleVertexColorBuffer = squareVertexPositionBuffer = squareVertexNormalBuffer = squareVertexColorBuffer = void 0;

camera = void 0;

m4 = twgl.m4;

mvMatrix = m4.identity();

mvMatrixStack = [];

pMatrix = m4.identity();

nMatrix = m4.identity();

rTri = 0;

rSquare = 0;

lastTime = 0;

initGL = function(canvas) {
  gl = canvas.getContext('experimental-webgl');
  gl.viewportWidth = canvas.width;
  return gl.viewportHeight = canvas.height;
};

initShaders = function() {
  var fragmentShader, vertexShader;
  fragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
  gl.shaderSource(fragmentShader, frag_shader);
  gl.compileShader(fragmentShader);
  vertexShader = gl.createShader(gl.VERTEX_SHADER);
  gl.shaderSource(vertexShader, vert_shader);
  gl.compileShader(vertexShader);
  shaderProgram = gl.createProgram();
  gl.attachShader(shaderProgram, vertexShader);
  gl.attachShader(shaderProgram, fragmentShader);
  gl.linkProgram(shaderProgram);
  if (!gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)) {
    alert('Could not initialise shaders');
  }
  gl.useProgram(shaderProgram);
  shaderProgram.vertexPositionAttribute = gl.getAttribLocation(shaderProgram, 'aVertexPosition');
  gl.enableVertexAttribArray(shaderProgram.vertexPositionAttribute);
  shaderProgram.vertexColorAttribute = gl.getAttribLocation(shaderProgram, 'aVertexColor');
  gl.enableVertexAttribArray(shaderProgram.vertexColorAttribute);
  shaderProgram.vertexNormalAttribute = gl.getAttribLocation(shaderProgram, 'aVertexNormal');
  gl.enableVertexAttribArray(shaderProgram.vertexNormalAttribute);
  shaderProgram.pMatrixUniform = gl.getUniformLocation(shaderProgram, 'uPMatrix');
  shaderProgram.mvMatrixUniform = gl.getUniformLocation(shaderProgram, 'uMVMatrix');
  return shaderProgram.nMatrixUniform = gl.getUniformLocation(shaderProgram, 'uNMatrix');
};

setMatrixUniforms = function() {
  gl.uniformMatrix4fv(shaderProgram.pMatrixUniform, false, pMatrix);
  gl.uniformMatrix4fv(shaderProgram.mvMatrixUniform, false, mvMatrix);
  nMatrix = m4.transpose(m4.inverse(mvMatrix));
  return gl.uniformMatrix4fv(shaderProgram.nMatrixUniform, false, nMatrix);
};

degToRad = function(degrees) {
  return degrees * Math.PI / 180;
};

createVertexBuffer = function(verts) {
  var buff;
  buff = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, buff);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(verts), gl.STATIC_DRAW);
  buff.itemSize = 3;
  buff.numItems = verts.length / 3;
  return buff;
};

createColorBuffer = function(colors) {
  var colorBuff;
  colorBuff = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, colorBuff);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW);
  colorBuff.itemSize = 4;
  colorBuff.numItems = colors.length / 4;
  return colorBuff;
};

initBuffers = function() {
  var color, colors, i, j, squareVerts, unpackedColors, vertexNormals;
  squareVerts = [-1.0, -1.0, 1.0, 1.0, -1.0, 1.0, -1.0, 1.0, 1.0, 1.0, 1.0, 1.0, -1.0, -1.0, -1.0, -1.0, 1.0, -1.0, 1.0, -1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0, -1.0, -1.0, 1.0, -1.0, -1.0, -1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0, -1.0, 1.0, 1.0, 1.0, 1.0, 1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, 1.0, -1.0, 1.0, -1.0, -1.0, 1.0, 1.0];
  squareVertexPositionBuffer = createVertexBuffer(squareVerts);
  console.log("squareverts length: " + squareVerts.length);
  colors = [[1.0, 0.0, 0.0, 1.0], [1.0, 1.0, 0.0, 1.0], [0.0, 1.0, 0.0, 1.0], [0.0, 0.5, 0.5, 1.0], [1.0, 0.0, 1.0, 1.0], [0.0, 0.0, 1.0, 1.0]];
  unpackedColors = [];
  for (i in colors) {
    color = colors[i];
    j = 0;
    while (j < 4) {
      unpackedColors = unpackedColors.concat(color);
      j++;
    }
  }
  squareVertexColorBuffer = createColorBuffer(unpackedColors);
  vertexNormals = [0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0];
  console.log("vertexNormals length:" + vertexNormals.length);
  return squareVertexNormalBuffer = createVertexBuffer(vertexNormals);
};

initDrawingConfigs = function() {
  gl.clearColor(0.0, 0.0, 0.0, 1.0);
  gl.enable(gl.DEPTH_TEST);
  return gl.viewport(0, 0, gl.viewportWidth, gl.viewportHeight);
};

camMatrix = function(e, g, t) {
  var u, w;
  w = v3.normalize(g);
  t = v3.normalize(t);
  u = v3.normalize(v3.cross(t, w));
  return trans(u[0], t[0], w[0], e[0], u[1], t[1], w[1], e[1], u[2], t[2], w[2], e[2], 0, 0, 0, 1);
};

clearScreen = function() {
  return gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
};

drawScene = function() {
  clearScreen();
  mat4.perspective(45, gl.viewportWidth / gl.viewportHeight, 0.1, 100.0, pMatrix);
  mat4.identity(mvMatrix);
  mat4.translate(mvMatrix, [0.0, 0.0, -7.0]);
  mat4.rotate(mvMatrix, degToRad(rSquare / 2), [1, 0, 0]);
  mat4.rotate(mvMatrix, degToRad(rSquare / 4), [0, 1, 0]);
  gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexPositionBuffer);
  gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, squareVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);
  gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexColorBuffer);
  gl.vertexAttribPointer(shaderProgram.vertexColorAttribute, squareVertexColorBuffer.itemSize, gl.FLOAT, false, 0, 0);
  gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexNormalBuffer);
  gl.vertexAttribPointer(shaderProgram.vertexNormalAttribute, squareVertexNormalBuffer.itemSize, gl.FLOAT, false, 0, 0);
  setMatrixUniforms();
  return gl.drawArrays(gl.TRIANGLE_STRIP, 0, squareVertexPositionBuffer.numItems);
};

update = function() {
  var elapsed, timeNow;
  timeNow = (new Date).getTime();
  if (lastTime !== 0) {
    elapsed = timeNow - lastTime;
    rTri += 90 * elapsed / 1000.0;
    rSquare += 75 * elapsed / 1000.0;
  }
  return lastTime = timeNow;
};

tick = function() {
  requestAnimFrame(tick);
  drawScene();
  return update();
};

webGLStart = function() {
  var canvas;
  canvas = document.getElementById('lesson03-canvas');
  initGL(canvas);
  initShaders();
  initBuffers();
  initDrawingConfigs();
  return tick();
};
