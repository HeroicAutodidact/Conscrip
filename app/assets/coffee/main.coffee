#CADjs draw
#A prototype by Gabriel Elkind and Krishnan Suresh

#State of the program
nodes = []         #Nodes in the program
selectedNodes = [] #Selected nodes
edges = []
arcs = []
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

##Displaying
clearAndFill = ->
  dCtx.fillStyle = '#EEEEEE'
  dCtx.fillRect(0,0, dCanvas.height, dCanvas.width)

displayNode = (node)->
  rad = 4
  dCtx.beginPath()
  dCtx.arc(node[0], node[1],rad,0,2*Math.PI)
  dCtx.fillStyle = "#888888"
  dCtx.fill()

##Clicking and moving
#tool modes
toolMode = NOTOOL = 0
ADDNODES = 1
MULTISELECT = 2

handleClick =  (x,y) ->
  if toolMode is ADDNODES
    addNode(x,y)
  if toolMode is NOTOOL
    if nodeUnderMouse()
      selectedNodes = [nodeUnderMouse()]
  if toolMode is MULTISELECT
    console.log "in Multiselect"
    if nodeUnderMouse()
      console.log "triggered"
      selectedNodes.push(nodeUnderMouse())
      console.log "#{selectedNodes}"

nodeUnderMouse = ->
  for n in nodes
    if Math.abs(n[0]-mx)<5 and Math.abs(n[1]-my)<5
      return n
  return undefined

handleMouseMove = (x, y) ->
  #set global mouse vars
  mx = x
  my = y

  #handle hovering
  hoverNode = nodeUnderMouse()

  #console.log "I'm moving to #{mx},#{my}"
  redraw()


displayHoverCircle = (n) ->
  #Displays a circle around a node to indicate mouse hover
  rad = 6
  dCtx.beginPath()
  dCtx.arc(n[0], n[1],rad,0,2*Math.PI)
  dCtx.fillStyle = "#888888"
  dCtx.stroke()

displaySelectionCircle = (n) ->
  #Displays a circle around a node to indicate mouse hover
  rad = 6
  dCtx.beginPath()
  dCtx.arc(n[0], n[1],rad,0,2*Math.PI)
  dCtx.fillStyle = "#888888"
  dCtx.stroke()

  rad = 4
  dCtx.beginPath()
  dCtx.arc(n[0], n[1],rad,0,2*Math.PI)
  dCtx.fillStyle = "#888888"
  dCtx.stroke()


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
  # Draw all arcs

$(document).click (e)->
  #Pass clicks that occur on the canvas to the handler
  h = dCanvas.height
  w = dCanvas.width
  handleClick mx, my unless mx>w or mx<0 or my>h or my<0

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

    when 190 #.
      toolMode = ADDNODES

    when 16
      toolMode = MULTISELECT
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