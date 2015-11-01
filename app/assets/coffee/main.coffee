#CADjs draw
#A prototype by Gabriel Elkind and Krishnan Suresh

#State of the program
nodes = []         #Nodes in the program
selectedNodes = [] #Selected nodes
edges = []
currentEdgeStart = undefined   #For the creation of edges
arcs = []

###Mouse state info###
clicking = false
dragging = false
hoverNode = undefined

####mouse coords###
mx = my = undefined

###Keeps track of mouse coordinates when mouse was clicked down###
downx = downy = undefined

dCanvas = undefined #Just what is drawn to the window
dCtx = undefined
resultStringDisplay = undefined
canvasScale = 1

#Grid settings
gridSize = 20
displayGrid = true

deselect = ->
  selectedNodes = []

##Adding features
addNode = (x,y)->
  nodes.push([x,y])
  redraw()
  return

###Displaying###

clearAndFill = ->
  dCtx.fillStyle = '#EEEEEE'
  dCtx.fillRect(0,0, dCanvas.height, dCanvas.width)

##Displaying Nodes
displayNode = (node)->
  rad = 4
  dCtx.beginPath()
  dCtx.arc(node[0], node[1],rad,0,2*Math.PI)
  dCtx.fillStyle = "#888888"
  dCtx.fill()

deleteNode = (nodeToDelete)->
  nodes = nodes.filter (n)-> n isnt nodeToDelete
  edges = edges.filter (e)-> nodeToDelete not in e

displayHoverCircle = (n) ->
  #Displays a circle around a node to indicate mouse hover
  rad = 8
  dCtx.beginPath()
  dCtx.arc(n[0], n[1],rad,0,2*Math.PI)
  dCtx.lineWidth = 2
  dCtx.strokeStyle = "#888888"
  dCtx.stroke()

displaySelectionCircle = (n) ->
  #Displays a circle around a node to indicate mouse hover
  rad = 5
  dCtx.beginPath()
  dCtx.arc(n[0], n[1],rad,0,2*Math.PI)
  dCtx.strokeStyle = "#888888"
  dCtx.lineWidth = 3
  dCtx.stroke()


###Displaying edges###
displayCurrentEdge = ->
  dCtx.beginPath()
  dCtx.moveTo currentEdgeStart[0], currentEdgeStart[1]
  dCtx.lineTo mx, my
  dCtx.strokeStyle = "#888888"
  dCtx.lineWidth = 2
  dCtx.stroke()

displayEdge = (e)->
  dCtx.beginPath()
  dCtx.moveTo e[0][0], e[0][1]
  dCtx.lineTo e[1][0], e[1][1]
  dCtx.strokeStyle = "#888888"
  dCtx.lineWidth = 3
  dCtx.stroke()

###Clicking and moving###
####tool modes###
toolMode = NOTOOL = 0
ADDNODES = 1
MULTISELECT = 2
STARTLINE = 3
FINISHLINE = 4

###Modifies the behavior of STARTLINE PRELINE and FINISHLINE if true###
makingPath = false

handleMouseDown =  (x,y) ->
  switch toolMode
    when ADDNODES
      deselect()
      addNode(x,y)
      if makingPath
        toolMode = FINISHLINE
        currentEdgeStart = nodeUnderMouse()
    when NOTOOL
      unless selectedNodes.length > 1 and nodeUnderMouse() in selectedNodes
        if nodeUnderMouse()?
          selectedNodes = [nodeUnderMouse()]
    when MULTISELECT
      if nodeUnderMouse()
        selectedNodes.push(nodeUnderMouse())
    when STARTLINE
      if nodeUnderMouse()
        currentEdgeStart = nodeUnderMouse()
        toolMode = FINISHLINE
    when FINISHLINE
      if nodeUnderMouse()
        edges.push([currentEdgeStart, nodeUnderMouse()])
        ###Get rid of any nodes selected###
        deselect()
        #toolMode = STARTLINE
        if makingPath
          currentEdgeStart = nodeUnderMouse()
        else
          currentEdgeStart = undefined
          toolMode = NOTOOL
      else if makingPath
        newPathNode = [mx, my]
        edges.push([currentEdgeStart, newPathNode])
        console.log edges
        currentEdgeStart = newPathNode
        nodes.push(newPathNode)


handleMouseUp = (x, y) ->

  ###To differentiate between tapping and dragging behavior###
  switch toolMode
    when NOTOOL
      if !dragging and selectedNodes.length > 1
        if nodeUnderMouse()
          selectedNodes = [nodeUnderMouse()]
        else
          selectedNodes = []
      #Select the node under the mouse if we didn't drag
      #if !dragging
  redraw()


nodeUnderMouse = ->
  for n in nodes
    if Math.abs(n[0]-mx)<5 and Math.abs(n[1]-my)<5
      return n
  return undefined

handleMouseMove = (x, y) ->
  #set global mouse vars
  dx = x-mx
  dy = y-my
  mx = x
  my = y
  #We're dragging if either is nonzero
  dragging = true if clicking and (!dx or !dy)

  #handle hovering
  hoverNode = nodeUnderMouse()

  #Handle node movement
  if clicking and toolMode is NOTOOL
    for n in selectedNodes
      n[0] += dx
      n[1] += dy

  #console.log "I'm moving to #{mx},#{my}"
  redraw()

###CADjs string creation and display###
stringRep = ""

getConnectedEdges = (n)->
  ###
  obviously it would be significantly more efficient to simply store
  this information in nodes and update it as we move along. Will be changed
  in further iterations
  ###
  return edges.filter (e) -> n in e

getCJSString = ->
  CJSString = ""
  continuities = []
  examinedEdges = []
  buildContinuity = (cont) ->
    connectedEdges = getConnectedEdges(cont[cont.length-1])
    console.log connectedEdges
    if connectedEdges.length > 2
      return "More than two edges are connected to a node!"
    if connectedEdges.length < 2
      return "Discontinuous"
    connectedEdgesWithoutLast = connectedEdges.filter (e) -> e not in examinedEdges
    nextEdge = connectedEdgesWithoutLast[0]
    examinedEdges.push(nextEdge)
    nextNode = (nextEdge.filter (n)-> n isnt cont[cont.length-1] )[0]
    if nextNode is cont[0]
      console.log "215"
      return JSON.stringify(cont)
    else
      return buildContinuity(cont.concat [nextNode])
  for e in edges
    ###Unless we've already looked at e...###
    unless e in examinedEdges
      ###Establish start node###
      newContinuity = buildContinuity([e[0]])
      continuities.push(newContinuity) unless newContinuity in continuities
  return continuities


init = ->
  dCanvas = document.getElementById 'theCanvas'
  dCtx = dCanvas.getContext '2d'
  resultStringDisplay = document.getElementById 'cjsstring'
  redraw()

update = ->
  #If the user is dragging, update the selected nodes

drawGrid = ->
  x = 0
  y = 0
  dCtx.strokeStyle = "#FFFFFF"
  dCtx.lineWidth = 2
  console.log "drawgrid"
  until y > dCanvas.height
    dCtx.beginPath()
    dCtx.moveTo(0,y)
    dCtx.lineTo(dCanvas.height, y)
    dCtx.stroke()
    y+=gridSize
  until x > dCanvas.width
    dCtx.beginPath()
    dCtx.moveTo(x,0)
    dCtx.lineTo(x,dCanvas.height)
    dCtx.stroke()
    x+=gridSize

redraw = ->
  #A function to display the the entire program
  #Should be called any time a model is modified
  clearAndFill()
  #If it's set on, draw the grid
  drawGrid() if displayGrid

  # Draw all nodes
  for n in nodes
    displayNode(n)

  #If I'm hovering over a node, display it
  if hoverNode# and not dragging
    displayHoverCircle hoverNode

  # Draw the selected nodes
  for n in selectedNodes
    displaySelectionCircle n

  #console.log "#{toolMode}"
  # Draw all edges
  if currentEdgeStart
    displayCurrentEdge()

  for e in edges
    displayEdge(e)

  # Draw all arcs

  ###Display the text CADJS string###
  resultStringDisplay.textContent = getCJSString()

clamp = (min,number,max) ->
  return Math.max(min, Math.min(number,max))
###
input handling
###
$(document).mousedown (e)->
  #Pass clicks that occur on the canvas to the handler
  h = dCanvas.height
  w = dCanvas.width
  clicking = true
  dragging = false #Will be set to true if the mouse moves while down
  handleMouseDown mx, my unless mx>w or mx<0 or my>h or my<0

$(document).mouseup (e)->
  h = dCanvas.height
  w = dCanvas.width
  clicking = false
  handleMouseUp clamp(0,mx,w),clamp(0,my,h)

$(document).mousemove (e)->
  h = dCanvas.height
  w = dCanvas.width
  x = e.pageX - $(dCanvas).offset().left
  y = e.pageY - $(dCanvas).offset().top
  handleMouseMove x, y unless x>w or x<0 or y>h or y<0

$(document).keydown (key)->
  switch parseInt key.which ,10
    # when 37 #left arrow pressed

    # when 38 #up

    # when 39 #right

    # when 40 #down
    when 27 #esc
      toolMode = NOTOOL
      selectedNodes = []
      currentEdgeStart = undefined

    when 190 #.
      toolMode = ADDNODES
      makingPath = false

    when 16 #shift
      toolMode = MULTISELECT
      makingPath = false

    when 76 #l
      if selectedNodes.length is 2
        edges.push([selectedNodes[0],selectedNodes[1]])
        selectedNodes = []
      else if selectedNodes.length is 1
          currentEdgeStart = selectedNodes[0]
          toolMode = FINISHLINE
      else
        toolMode = STARTLINE
      makingPath = false
    when 78 #n
      toolMode = ADDNODES
      makingPath = true
      console.log "makingPath"
    when 88
      for n in selectedNodes
        deleteNode(n)
      selectedNodes = []
    when 64
      for n in selectedNodes
        deleteNode(n)
      selectedNodes = []
    else
      console.log "I'm pressing key: #{key.which}"
  #No matter what
  redraw()

$(document).keyup (key) ->
  switch parseInt key.which, 10
    when 16
      toolMode = NOTOOL if toolMode is MULTISELECT

$(document).ready ->
  init()