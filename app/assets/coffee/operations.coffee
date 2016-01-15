Node = require './node'

Operations =
  context: undefined #Must be linked for module to function
  mousehandle: undefined #Must be linked for module to function
  ###
  Direct data manipulation functions
  ###
  placeNode: ->
    ###Places a node underneat the mouse###
    [x,y] = @mousehandle.position()
    console.log @context
    @context.selectedSketch.nodes.push new Node(x,y)

module.exports = Operations