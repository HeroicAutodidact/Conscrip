#CADjs draw
#A prototype by Gabriel Elkind and Krishnan Suresh

#State of the program
nodes = []         #Nodes in the program
selectedNodes = [] #Selected nodes
edges = []
currentEdgeStart = undefined   #For the creation of edges
arcs = []
clicking = false
dragging = false
hoverNode = undefined

#mouse coords
mx = my = undefined

dCanvas = undefined #Just what is drawn to the window
dCtx = undefined
canvasScale = 1

#Grid settings
gridSize = undefined
displayGrid = false

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

  # rad = 4
  # dCtx.beginPath()
  # dCtx.arc(n[0], n[1],rad,0,2*Math.PI)
  # dCtx.fillStyle = "#888888"
  # dCtx.stroke()

##Displaying edges
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

##Clicking and moving
#tool modes
toolMode = NOTOOL = 0
ADDNODES = 1
MULTISELECT = 2
STARTLINE = 3
FINISHLINE = 4

handleClick =  (x,y) ->
  switch toolMode
    when ADDNODES
      addNode(x,y)
    when NOTOOL
      if nodeUnderMouse()
        selectedNodes = [nodeUnderMouse()]
      else
        selectedNodes = []
    when MULTISELECT
      console.log "in Multiselect"
      if nodeUnderMouse()
        console.log "triggered"
        selectedNodes.push(nodeUnderMouse())
        console.log "#{selectedNodes}"
    when STARTLINE
      if nodeUnderMouse()
        currentEdgeStart = nodeUnderMouse()
        toolMode = FINISHLINE
    when FINISHLINE
      if nodeUnderMouse()
        edges.push([currentEdgeStart, nodeUnderMouse()])
        currentEdgeStart = undefined
        toolMode = STARTLINE



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

  #handle hovering
  hoverNode = nodeUnderMouse()

  #Handle node movement
  if clicking and toolMode is NOTOOL
    for n in selectedNodes
      n[0] += dx
      n[1] += dy

  #console.log "I'm moving to #{mx},#{my}"
  redraw()



updateDrag = ->
  #Update the position of selected objects
  #If there's grid snapping, snap objects to grid

doneDragging = ->
  #Turn off dragging
  #commit the change to the

init = ->
  dCanvas = document.getElementById 'theCanvas'
  dCtx = dCanvas.getContext '2d'
  clearAndFill()

update = ->
  #If the user is dragging, update the selected nodes

redraw = ->
  #A function to display the the entire program
  #Should be called any time a model is modified
  clearAndFill()
  #If it's set on, draw the grid

  # Draw all nodes
  for n in nodes
    displayNode(n)

  #If I'm hovering over a node, display it
  if hoverNode
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

$(document).mousedown (e)->
  #Pass clicks that occur on the canvas to the handler
  h = dCanvas.height
  w = dCanvas.width
  clicking = true
  handleClick mx, my unless mx>w or mx<0 or my>h or my<0

$(document).mouseup (e)->
  console.log "mouseup"
  clicking = false

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

    when 16 #shift
      toolMode = MULTISELECT

    when 76 #l
      if selectedNodes.length is 2
        edges.push([selectedNodes[0],selectedNodes[1]])
      else
        if selectedNodes.length is 1
          currentEdgeStart = selectedNodes[0]
        toolMode = FINISHLINE
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