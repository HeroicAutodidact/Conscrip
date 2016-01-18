Point = require './point'
Edge = require './edge'
log = require './log'

module.exports = new class Operations
  ###
  A singleton module containing methods for manipulating
  sketchdata
  ###
  constructor: ->
    @context = undefined
    @mousehandle = undefined

  placePoint: =>
    [x,y] = @mousehandle.position()
    @context.selected.sketch.points.push new Point(x,y)

  selectPoint: (point)=>
    @context.select_point point

  selectHovered: =>
    ###
    For now, we'll just take the first point
    but eventually, there needs to be a way of making
    distinctions when objects are close together or overlapping
    ###
    pointUnderMouse = @context.hovered.points[0]
    @selectPoint pointUnderMouse if pointUnderMouse?

  connectSelectedPoints: =>
    spoints = @context.selected.points
    if spoints.length isnt 2
      log "Can't connect, #{spoints.length} points are selected, need exactly 2"

    ###SHOULD be eventually replaced with a collection method ensuring uniqueness###
    newedge = new Edge(spoints[0], spoints[1])
    for e in @context.selected.sketch.edges
      if e.equals newedge
        return
    @context.selected.sketch.edges.push newedge
    ###ENDSHOULD###




# Operations =
#   context: undefined #Must be linked for module to function
#   mousehandle: undefined #Must be linked for module to function
#   ###
#   Direct manipulation of selected sketch
#   ###
#   placePoint: ->
#     ###Places a point underneat the mouse###
#     [x,y] = @mousehandle.position()
#     @context.selected.sketch.points.push new Point(x,y)

#   selectPoint: (point)=>
#     @context.selectPoint point

#   selectHovered: =>
#     ###
#     For now, we'll just take the first point
#     but eventually, there needs to be a way of making
#     distinctions when objects are close together or overlapping
#     ###
#     @selectPoint @context.hovered.points[0]

# module.exports = Operations