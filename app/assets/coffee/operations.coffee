Point = require './point'

Operations =
  context: undefined #Must be linked for module to function
  mousehandle: undefined #Must be linked for module to function
  ###
  Direct manipulation of selected sketch
  ###
  placePoint: ->
    ###Places a node underneat the mouse###
    [x,y] = @mousehandle.position()
    console.log @context
    @context.selected.sketch().points.push new Point(x,y)

  selectPoint: (point)->
    @context.selectPoint point

  selectHovered: ->
    ###
    For now, we'll just take the first point
    but eventually, there needs to be a way of making
    distinctions when objects are close together or overlapping
    ###
    @context.selectPoint context.hovered.points[0]

module.exports = Operations