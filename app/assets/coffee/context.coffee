context =
	selected:
		sketch: undefined
		points: []
		edges: []
	hovered:
		points: []
		edges: []
	###Note: Perhaps later I can make a more elegant naming scheme
	say, specifying subobjects such as context.select.sketch(<sketch>)###
	selectSketch: (sketch)->
			@selected.sketch = sketch
			return
	selectPoint: (point)->
			@selected.points.push point
			return
	hoverPoint: (point)->
			@hovered.points.push point
	deselectAll: ->
		###Clear all arrays ###
		@selected.points.length = 0
		@selected.edges.length = 0

module.exports = context