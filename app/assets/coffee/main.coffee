#GL globals
gl =
shaderProgram =
triangleVertexPositionBuffer =
triangleVertexColorBuffer =
squareVertexPositionBuffer =
squareVertexColorBuffer = undefined

#Initialize global matrices
m4 = twgl.m4
mvMatrix = m4.identity()
mvMatrixStack = []
pMatrix = m4.identity()

rTri = 0
rSquare = 0
lastTime = 0

initGL = (canvas) ->
  gl = canvas.getContext('experimental-webgl')
  gl.viewportWidth = canvas.width
  gl.viewportHeight = canvas.height

getShader = (gl, id) ->
  shaderScript = document.getElementById(id)
  if !shaderScript
    return null
  str = ''
  k = shaderScript.firstChild
  while k
    if k.nodeType == 3
      str += k.textContent
    k = k.nextSibling
  shader = undefined
  if shaderScript.type == 'x-shader/x-fragment'
    shader = gl.createShader(gl.FRAGMENT_SHADER)
  else if shaderScript.type == 'x-shader/x-vertex'
    shader = gl.createShader(gl.VERTEX_SHADER)
  else
    return null
  gl.shaderSource shader, str
  gl.compileShader shader
  if !gl.getShaderParameter(shader, gl.COMPILE_STATUS)
    alert gl.getShaderInfoLog(shader)
    return null
  shader

initShaders = ->
  fragmentShader = getShader(gl, 'shader-fs')
  vertexShader = getShader(gl, 'shader-vs')
  shaderProgram = gl.createProgram()
  gl.attachShader shaderProgram, vertexShader
  gl.attachShader shaderProgram, fragmentShader
  gl.linkProgram shaderProgram
  if !gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)
    alert 'Could not initialise shaders'
  gl.useProgram shaderProgram
  shaderProgram.vertexPositionAttribute = gl.getAttribLocation(shaderProgram, 'aVertexPosition')
  gl.enableVertexAttribArray shaderProgram.vertexPositionAttribute
  shaderProgram.vertexColorAttribute = gl.getAttribLocation(shaderProgram, 'aVertexColor')
  gl.enableVertexAttribArray shaderProgram.vertexColorAttribute
  shaderProgram.pMatrixUniform = gl.getUniformLocation(shaderProgram, 'uPMatrix')
  shaderProgram.mvMatrixUniform = gl.getUniformLocation(shaderProgram, 'uMVMatrix')

mvPushMatrix = ->
  copy = mat4.create()
  mat4.set mvMatrix, copy
  mvMatrixStack.push copy
  return

mvPopMatrix = ->
  if mvMatrixStack.length == 0
    throw 'Invalid popMatrix!'
  mvMatrix = mvMatrixStack.pop()
  return

setMatrixUniforms = ->
  gl.uniformMatrix4fv shaderProgram.pMatrixUniform, false, pMatrix
  gl.uniformMatrix4fv shaderProgram.mvMatrixUniform, false, mvMatrix
  return

degToRad = (degrees) ->
  degrees * Math.PI / 180

createVertexBuffer = (verts)->
  buff = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, buff
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(verts), gl.STATIC_DRAW
  buff.itemSize = 3
  buff.numItems = verts.length / 3
  return buff

createColorBuffer = (colors)->
  colorBuff = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, colorBuff
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW
  colorBuff.itemSize = 4
  colorBuff.numItems = colors.length/4
  return colorBuff

initBuffers = ->
  triVerts = [
    0.0, 1.0, 0.0,
    -1.0, -1.0, 0.0,
    1.0, -1.0, 0.0
  ]
  triangleVertexPositionBuffer = createVertexBuffer(triVerts)

  colorsRGB = [
    1.0, 0.0, 0.0, 1.0,
    0.0, 1.0, 0.0, 1.0,
    0.0, 0.0, 1.0, 1.0
  ]
  triangleVertexColorBuffer = createColorBuffer(colorsRGB)


  squareVerts = [
      # Front face
      -1.0, -1.0,  1.0,
       1.0, -1.0,  1.0,
       1.0,  1.0,  1.0,
      -1.0,  1.0,  1.0,

      # Back face
      -1.0, -1.0, -1.0,
      -1.0,  1.0, -1.0,
       1.0,  1.0, -1.0,
       1.0, -1.0, -1.0,

      # Top face
      -1.0,  1.0, -1.0,
      -1.0,  1.0,  1.0,
       1.0,  1.0,  1.0,
       1.0,  1.0, -1.0,

      # Bottom face
      -1.0, -1.0, -1.0,
       1.0, -1.0, -1.0,
       1.0, -1.0,  1.0,
      -1.0, -1.0,  1.0,

      # Right face
       1.0, -1.0, -1.0,
       1.0,  1.0, -1.0,
       1.0,  1.0,  1.0,
       1.0, -1.0,  1.0,

      # Left face
      -1.0, -1.0, -1.0,
      -1.0, -1.0,  1.0,
      -1.0,  1.0,  1.0,
      -1.0,  1.0, -1.0,
    ];
  squareVertexPositionBuffer = createVertexBuffer(squareVerts)

  colors = []
  i = 0
  while i<squareVerts.length/3
    console.log "lol"
    colors = colors.concat([0.5, 0.5, 1.0, 1.0 ])
    i+=1
  squareVertexColorBuffer = createColorBuffer(colors)

initDrawingConfigs = ->
  gl.clearColor 0.0, 0.0, 0.0, 1.0
  gl.enable gl.DEPTH_TEST
  gl.viewport 0, 0, gl.viewportWidth, gl.viewportHeight

clearScreen = ->
  gl.clear gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT

drawScene = ->
  clearScreen()
  mat4.perspective 45, gl.viewportWidth / gl.viewportHeight, 0.1, 100.0, pMatrix
  mat4.identity mvMatrix
  mat4.translate mvMatrix, [-1.5, 0.0, -7.0 ]
  mvPushMatrix()
  mat4.rotate mvMatrix, degToRad(rTri), [0, 1, 0]
  gl.bindBuffer gl.ARRAY_BUFFER, triangleVertexPositionBuffer
  gl.vertexAttribPointer shaderProgram.vertexPositionAttribute, triangleVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0
  gl.bindBuffer gl.ARRAY_BUFFER, triangleVertexColorBuffer
  gl.vertexAttribPointer shaderProgram.vertexColorAttribute, triangleVertexColorBuffer.itemSize, gl.FLOAT, false, 0, 0
  setMatrixUniforms()
  gl.drawArrays gl.TRIANGLES, 0, triangleVertexPositionBuffer.numItems
  mvPopMatrix()
  mat4.translate mvMatrix, [3.0, 0.0, 0.0 ]
  mvPushMatrix()
  mat4.rotate mvMatrix, degToRad(rSquare), [1, 0, 0 ]
  gl.bindBuffer gl.ARRAY_BUFFER, squareVertexPositionBuffer
  gl.vertexAttribPointer shaderProgram.vertexPositionAttribute, squareVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0
  gl.bindBuffer gl.ARRAY_BUFFER, squareVertexColorBuffer
  gl.vertexAttribPointer shaderProgram.vertexColorAttribute, squareVertexColorBuffer.itemSize, gl.FLOAT, false, 0, 0
  setMatrixUniforms()
  gl.drawArrays gl.TRIANGLE_STRIP, 0, squareVertexPositionBuffer.numItems
  mvPopMatrix()

update = ->
  timeNow = (new Date).getTime()
  if lastTime != 0
    elapsed = timeNow - lastTime
    rTri += 90 * elapsed / 1000.0
    rSquare += 75 * elapsed / 1000.0
  lastTime = timeNow

tick = ->
  requestAnimFrame tick
  drawScene()
  update()

webGLStart = ->
  canvas = document.getElementById('lesson03-canvas')
  initGL canvas
  initShaders()
  initBuffers()
  initDrawingConfigs()
  tick()

