var clearScreen, createColorBuffer, createVertexBuffer, degToRad, drawScene, getShader, gl, initBuffers, initDrawingConfigs, initGL, initShaders, lastTime, m4, mvMatrix, mvMatrixStack, mvPopMatrix, mvPushMatrix, pMatrix, rSquare, rTri, setMatrixUniforms, shaderProgram, squareVertexColorBuffer, squareVertexPositionBuffer, tick, triangleVertexColorBuffer, triangleVertexPositionBuffer, update, webGLStart;

gl = shaderProgram = triangleVertexPositionBuffer = triangleVertexColorBuffer = squareVertexPositionBuffer = squareVertexColorBuffer = void 0;

m4 = twgl.m4;

mvMatrix = m4.identity();

mvMatrixStack = [];

pMatrix = m4.identity();

rTri = 0;

rSquare = 0;

lastTime = 0;

initGL = function(canvas) {
  gl = canvas.getContext('experimental-webgl');
  gl.viewportWidth = canvas.width;
  return gl.viewportHeight = canvas.height;
};

getShader = function(gl, id) {
  var k, shader, shaderScript, str;
  shaderScript = document.getElementById(id);
  if (!shaderScript) {
    return null;
  }
  str = '';
  k = shaderScript.firstChild;
  while (k) {
    if (k.nodeType === 3) {
      str += k.textContent;
    }
    k = k.nextSibling;
  }
  shader = void 0;
  if (shaderScript.type === 'x-shader/x-fragment') {
    shader = gl.createShader(gl.FRAGMENT_SHADER);
  } else if (shaderScript.type === 'x-shader/x-vertex') {
    shader = gl.createShader(gl.VERTEX_SHADER);
  } else {
    return null;
  }
  gl.shaderSource(shader, str);
  gl.compileShader(shader);
  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    alert(gl.getShaderInfoLog(shader));
    return null;
  }
  return shader;
};

initShaders = function() {
  var fragmentShader, vertexShader;
  fragmentShader = getShader(gl, 'shader-fs');
  vertexShader = getShader(gl, 'shader-vs');
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
  shaderProgram.pMatrixUniform = gl.getUniformLocation(shaderProgram, 'uPMatrix');
  return shaderProgram.mvMatrixUniform = gl.getUniformLocation(shaderProgram, 'uMVMatrix');
};

mvPushMatrix = function() {
  var copy;
  copy = mat4.create();
  mat4.set(mvMatrix, copy);
  return mvMatrixStack.push(copy);
};

mvPopMatrix = function() {
  if (mvMatrixStack.length === 0) {
    throw 'Invalid popMatrix!';
  }
  return mvMatrix = mvMatrixStack.pop();
};

setMatrixUniforms = function() {
  gl.uniformMatrix4fv(shaderProgram.pMatrixUniform, false, pMatrix);
  return gl.uniformMatrix4fv(shaderProgram.mvMatrixUniform, false, mvMatrix);
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
  var colors, colorsRGB, i, squareVerts, triVerts;
  triVerts = [0.0, 1.0, 0.0, -1.0, -1.0, 0.0, 1.0, -1.0, 0.0];
  triangleVertexPositionBuffer = createVertexBuffer(triVerts);
  colorsRGB = [1.0, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0];
  triangleVertexColorBuffer = createColorBuffer(colorsRGB);
  squareVerts = [-1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0, -1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0, -1.0, -1.0, -1.0, 1.0, -1.0, -1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, -1.0, -1.0, -1.0, -1.0, 1.0, -1.0, -1.0, 1.0, -1.0, 1.0, -1.0, -1.0, 1.0, 1.0, -1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0, 1.0, 1.0, -1.0, 1.0, -1.0, -1.0, -1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0, -1.0];
  squareVertexPositionBuffer = createVertexBuffer(squareVerts);
  colors = [];
  i = 0;
  while (i < squareVerts.length / 3) {
    console.log("lol");
    colors = colors.concat([0.5, 0.5, 1.0, 1.0]);
    i += 1;
  }
  return squareVertexColorBuffer = createColorBuffer(colors);
};

initDrawingConfigs = function() {
  gl.clearColor(0.0, 0.0, 0.0, 1.0);
  gl.enable(gl.DEPTH_TEST);
  return gl.viewport(0, 0, gl.viewportWidth, gl.viewportHeight);
};

clearScreen = function() {
  return gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
};

drawScene = function() {
  clearScreen();
  mat4.perspective(45, gl.viewportWidth / gl.viewportHeight, 0.1, 100.0, pMatrix);
  mat4.identity(mvMatrix);
  mat4.translate(mvMatrix, [0.0, 0.0, -7.0]);
  mat4.rotate(mvMatrix, degToRad(rSquare), [1, 0, 0]);
  gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexPositionBuffer);
  gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, squareVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);
  gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexColorBuffer);
  gl.vertexAttribPointer(shaderProgram.vertexColorAttribute, squareVertexColorBuffer.itemSize, gl.FLOAT, false, 0, 0);
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
