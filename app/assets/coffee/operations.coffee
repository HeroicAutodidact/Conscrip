Point = require './point'

module.exports = new class Operations
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
    @selectPoint @context.hovered.points[0]

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