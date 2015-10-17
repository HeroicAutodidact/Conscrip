#GL globals
gl =
shaderProgram =
triangleVertexPositionBuffer =
triangleVertexColorBuffer =
squareVertexPositionBuffer =
squareVertexNormalBuffer =
squareVertexColorBuffer = undefined
camera = undefined

#Initialize global matrices
m4 = twgl.m4
mvMatrix = m4.identity()
mvMatrixStack = []
pMatrix = m4.identity()
nMatrix = m4.identity()


rTri = 0
rSquare = 0
lastTime = 0

initGL = (canvas) ->
  gl = canvas.getContext('experimental-webgl')
  gl.viewportWidth = canvas.width
  gl.viewportHeight = canvas.height

initShaders = ->
  #Make frag shader
  fragmentShader = gl.createShader(gl.FRAGMENT_SHADER)
  gl.shaderSource fragmentShader, frag_shader
  gl.compileShader fragmentShader

  #Make vertex shader
  vertexShader = gl.createShader(gl.VERTEX_SHADER)
  gl.shaderSource vertexShader, vert_shader
  gl.compileShader vertexShader

  #initiate shader
  shaderProgram = gl.createProgram()

  #Attach our two programs
  gl.attachShader shaderProgram, vertexShader
  gl.attachShader shaderProgram, fragmentShader

  #Link the program to the graphics card ?
  gl.linkProgram shaderProgram
  if !gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)
    alert 'Could not initialise shaders'
  gl.useProgram shaderProgram

  #Declare attributes and handles
  shaderProgram.vertexPositionAttribute = gl.getAttribLocation(shaderProgram, 'aVertexPosition')
  gl.enableVertexAttribArray shaderProgram.vertexPositionAttribute
  shaderProgram.vertexColorAttribute = gl.getAttribLocation(shaderProgram, 'aVertexColor')
  gl.enableVertexAttribArray shaderProgram.vertexColorAttribute
  shaderProgram.vertexNormalAttribute = gl.getAttribLocation(shaderProgram, 'aVertexNormal')
  gl.enableVertexAttribArray shaderProgram.vertexNormalAttribute

  shaderProgram.pMatrixUniform = gl.getUniformLocation(shaderProgram, 'uPMatrix')
  shaderProgram.mvMatrixUniform = gl.getUniformLocation(shaderProgram, 'uMVMatrix')
  shaderProgram.nMatrixUniform = gl.getUniformLocation(shaderProgram, 'uNMatrix')

setMatrixUniforms = ->
  gl.uniformMatrix4fv shaderProgram.pMatrixUniform, false, pMatrix
  gl.uniformMatrix4fv shaderProgram.mvMatrixUniform, false, mvMatrix
  nMatrix = m4.transpose(m4.inverse(mvMatrix))
  gl.uniformMatrix4fv shaderProgram.nMatrixUniform, false, nMatrix
  # console.log "#{nMatrix}" confirmed.... matrix is changing

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

  squareVerts = [
      # Front face
      -1.0, -1.0,  1.0,
       1.0, -1.0,  1.0,
      -1.0,  1.0,  1.0,
       1.0,  1.0,  1.0,

      # Back face
      -1.0, -1.0, -1.0,
      -1.0,  1.0, -1.0,
       1.0, -1.0, -1.0,
       1.0,  1.0, -1.0,

      # Top face
       1.0,  1.0, -1.0,
      -1.0,  1.0, -1.0,
       1.0,  1.0,  1.0,
      -1.0,  1.0,  1.0,

      # Bottom face
      -1.0, -1.0, -1.0,
       1.0, -1.0, -1.0,
      -1.0, -1.0,  1.0,
       1.0, -1.0,  1.0,

      # Right face (magenta)
       1.0, -1.0,  1.0,
       1.0, -1.0, -1.0,
       1.0,  1.0,  1.0,
       1.0,  1.0, -1.0,

      # Left face
      -1.0, -1.0, -1.0,
      -1.0, -1.0,  1.0,
      -1.0,  1.0, -1.0,
      -1.0,  1.0,  1.0,
    ];
  squareVertexPositionBuffer = createVertexBuffer(squareVerts)
  console.log "squareverts length: #{squareVerts.length}"

  colors = [
      [1.0, 0.0, 0.0, 1.0], # Front face (RED)
      [1.0, 1.0, 0.0, 1.0], # Back face (Yellow)
      [0.0, 1.0, 0.0, 1.0], # Top face (Green)
      [0.0, 0.5, 0.5, 1.0], # Bottom face (probably teal)
      [1.0, 0.0, 1.0, 1.0], # Right face (Magenta)
      [0.0, 0.0, 1.0, 1.0]  # Left face (Blue)
  ];
  unpackedColors = []
  for i of colors
    color = colors[i]
    j = 0
    while j < 4
      unpackedColors = unpackedColors.concat(color)
      j++


  # i = 0
  # while i<squareVerts.length/3
  #   colors = colors.concat([0.5, 0.5, 1.0, 1.0 ])
  #   i+=1
  squareVertexColorBuffer = createColorBuffer(unpackedColors)

  vertexNormals = [
      # Front face
      0.0,  0.0,  1.0,
      0.0,  0.0,  1.0,
      0.0,  0.0,  1.0,
      0.0,  0.0,  1.0,

      # Back face
      0.0,  0.0, -1.0,
      0.0,  0.0, -1.0,
      0.0,  0.0, -1.0,
      0.0,  0.0, -1.0,

      # Top face
      0.0,  1.0,  0.0,
      0.0,  1.0,  0.0,
      0.0,  1.0,  0.0,
      0.0,  1.0,  0.0,

      # Bottom face
      0.0, -1.0,  0.0,
      0.0, -1.0,  0.0,
      0.0, -1.0,  0.0,
      0.0, -1.0,  0.0,

      # Right face
      1.0,  0.0,  0.0,
      1.0,  0.0,  0.0,
      1.0,  0.0,  0.0,
      1.0,  0.0,  0.0,

      # Left face
      -1.0,  0.0,  0.0,
      -1.0,  0.0,  0.0,
      -1.0,  0.0,  0.0,
      -1.0,  0.0,  0.0,
    ];
  console.log "vertexNormals length:#{vertexNormals.length}"
  squareVertexNormalBuffer = createVertexBuffer(vertexNormals)

initDrawingConfigs = ->
  gl.clearColor 0.0, 0.0, 0.0, 1.0
  gl.enable gl.DEPTH_TEST
  gl.viewport 0, 0, gl.viewportWidth, gl.viewportHeight

camMatrix = (e,g,t)->
  w = v3.normalize(g);
  t = v3.normalize(t);
  u = v3.normalize(v3.cross(t,w));

  return trans(u[0], t[0], w[0], e[0],
               u[1], t[1], w[1], e[1],
               u[2], t[2], w[2], e[2],
               0,    0,    0,   1);

clearScreen = ->
  gl.clear gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT

drawScene = ->
  #Clear the screen
  clearScreen()

  #Build the perspective Matrix
  mat4.perspective 45, gl.viewportWidth / gl.viewportHeight, 0.1, 100.0, pMatrix

  #Clear the transform matrix
  mat4.identity mvMatrix
  mat4.translate mvMatrix, [0.0, 0.0, -7.0 ]
  mat4.rotate mvMatrix, degToRad(rSquare/2), [1, 0, 0 ]
  mat4.rotate mvMatrix, degToRad(rSquare/4), [0, 1, 0 ]
  gl.bindBuffer gl.ARRAY_BUFFER, squareVertexPositionBuffer
  gl.vertexAttribPointer shaderProgram.vertexPositionAttribute, squareVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0
  gl.bindBuffer gl.ARRAY_BUFFER, squareVertexColorBuffer
  gl.vertexAttribPointer shaderProgram.vertexColorAttribute, squareVertexColorBuffer.itemSize, gl.FLOAT, false, 0, 0
  gl.bindBuffer gl.ARRAY_BUFFER, squareVertexNormalBuffer
  gl.vertexAttribPointer shaderProgram.vertexNormalAttribute, squareVertexNormalBuffer.itemSize, gl.FLOAT, false, 0, 0
  setMatrixUniforms()
  gl.drawArrays gl.TRIANGLE_STRIP, 0, squareVertexPositionBuffer.numItems
  # gl.drawArrays gl.TRIANGLES, 0, squareVertexPositionBuffer.numItems

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
  # camera = new Camera(canvas)
  initGL canvas
  initShaders()
  initBuffers()
  initDrawingConfigs()
  tick()

