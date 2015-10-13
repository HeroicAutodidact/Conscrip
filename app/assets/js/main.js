var degToRad, drawScene, getShader, gl, initBuffers, initGL, initShaders, lastTime, mvMatrix, mvMatrixStack, mvPopMatrix, mvPushMatrix, pMatrix, rSquare, rTri, setMatrixUniforms, shaderProgram, squareVertexColorBuffer, squareVertexPositionBuffer, tick, triangleVertexColorBuffer, triangleVertexPositionBuffer, update, webGLStart;

gl = shaderProgram = triangleVertexPositionBuffer = triangleVertexColorBuffer = squareVertexPositionBuffer = squareVertexColorBuffer = void 0;

mvMatrix = mat4.create();

mvMatrixStack = [];

pMatrix = mat4.create();

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
  shaderProgram.mvMatrixUniform = gl.getUniformLocation(shaderProgram, 'uMVMatrix');
};

mvPushMatrix = function() {
  var copy;
  copy = mat4.create();
  mat4.set(mvMatrix, copy);
  mvMatrixStack.push(copy);
};

mvPopMatrix = function() {
  if (mvMatrixStack.length === 0) {
    throw 'Invalid popMatrix!';
  }
  mvMatrix = mvMatrixStack.pop();
};

setMatrixUniforms = function() {
  gl.uniformMatrix4fv(shaderProgram.pMatrixUniform, false, pMatrix);
  gl.uniformMatrix4fv(shaderProgram.mvMatrixUniform, false, mvMatrix);
};

degToRad = function(degrees) {
  return degrees * Math.PI / 180;
};

initBuffers = function() {
  var colors, i, vertices;
  triangleVertexPositionBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, triangleVertexPositionBuffer);
  vertices = [0.0, 1.0, 0.0, -1.0, -1.0, 0.0, 1.0, -1.0, 0.0];
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
  triangleVertexPositionBuffer.itemSize = 3;
  triangleVertexPositionBuffer.numItems = 3;
  triangleVertexColorBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, triangleVertexColorBuffer);
  colors = [1.0, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0];
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW);
  triangleVertexColorBuffer.itemSize = 4;
  triangleVertexColorBuffer.numItems = 3;
  squareVertexPositionBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexPositionBuffer);
  vertices = [1.0, 1.0, 0.0, -1.0, 1.0, 0.0, 1.0, -1.0, 0.0, -1.0, -1.0, 0.0];
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
  squareVertexPositionBuffer.itemSize = 3;
  squareVertexPositionBuffer.numItems = 4;
  squareVertexColorBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexColorBuffer);
  colors = [];
  i = 0;
  while (i < 4) {
    colors = colors.concat([0.5, 0.5, 1.0, 1.0]);
    i++;
  }
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW);
  squareVertexColorBuffer.itemSize = 4;
  squareVertexColorBuffer.numItems = 4;
};

drawScene = function() {
  gl.viewport(0, 0, gl.viewportWidth, gl.viewportHeight);
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  mat4.perspective(45, gl.viewportWidth / gl.viewportHeight, 0.1, 100.0, pMatrix);
  mat4.identity(mvMatrix);
  mat4.translate(mvMatrix, [-1.5, 0.0, -7.0]);
  mvPushMatrix();
  mat4.rotate(mvMatrix, degToRad(rTri), [0, 1, 0]);
  gl.bindBuffer(gl.ARRAY_BUFFER, triangleVertexPositionBuffer);
  gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, triangleVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);
  gl.bindBuffer(gl.ARRAY_BUFFER, triangleVertexColorBuffer);
  gl.vertexAttribPointer(shaderProgram.vertexColorAttribute, triangleVertexColorBuffer.itemSize, gl.FLOAT, false, 0, 0);
  setMatrixUniforms();
  gl.drawArrays(gl.TRIANGLES, 0, triangleVertexPositionBuffer.numItems);
  mvPopMatrix();
  mat4.translate(mvMatrix, [3.0, 0.0, 0.0]);
  mvPushMatrix();
  mat4.rotate(mvMatrix, degToRad(rSquare), [1, 0, 0]);
  gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexPositionBuffer);
  gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, squareVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);
  gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexColorBuffer);
  gl.vertexAttribPointer(shaderProgram.vertexColorAttribute, squareVertexColorBuffer.itemSize, gl.FLOAT, false, 0, 0);
  setMatrixUniforms();
  gl.drawArrays(gl.TRIANGLE_STRIP, 0, squareVertexPositionBuffer.numItems);
  return mvPopMatrix();
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
  gl.clearColor(0.0, 0.0, 0.0, 1.0);
  gl.enable(gl.DEPTH_TEST);
  return tick();
};