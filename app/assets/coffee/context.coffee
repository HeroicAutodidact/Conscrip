###
context.coffee
###
module.exports = do ->
	###
	The interface which other modules will use to access context
	###
	inter = {}


	###Selection data###
	selected =
		sketch: undefined
		points: []
		edges: []

	#Getters
	inter.selected = {}
	inter.selected.sketch = -> selected.sketch
	inter.selected.points = -> selected.points
	inter.selected.edges = -> selected.edges

	#setters
	inter.select = {}
	inter.select.sketch = (sketch)-> selected.sketch = sketch
	inter.select.point = (point)-> selected.points.push point
	inter.select.edge = (edge)-> selected.edges.push edge

	###Hover data###
	hovered =
		points: []
		edges: []

	#getters
	inter.hovered = {}
	inter.hovered.points = -> hovered.points
	inter.hovered.edges = -> hovered.edges

	#setters
	inter.hover = {}
	inter.hover.point = (point)-> hovered.points.push point

	###Push up the interface###
	return inter
	# selected:
	# 	sketch: undefined
	# 	points: []
	# 	edges: []
	# hovered:
	# 	points: []
	# 	edges: []
	# ###Note: Perhaps later I can make a more elegant naming scheme
	# say, specifying subobjects such as context.select.sketch(<sketch>)###
	# selectSketch: (sketch)->
	# 		@selected.sketch = sketch
	# 		return
	# selectPoint: (point)->
	# 		@selected.points.push point
	# 		return
	# hoverPoint: (point)->
	# 		@hovered.points.push point
	# deselectAll: ->
	# 	###Clear all arrays ###
	# 	@selected.points.length = 0
	# 	@selected.edges.length = 0

# module.exports = context