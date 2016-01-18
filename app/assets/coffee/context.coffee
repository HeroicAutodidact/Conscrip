###
context.coffee
###
# module.exports = do ->
# 	###
# 	The interface which other modules will use to access context
# 	###
# 	inter = {}


# 	###Selection data###
# 	selected =
# 		sketch: undefined
# 		points: []
# 		edges: []

# 	#Getters
# 	inter.selected = {}
# 	inter.selected.sketch = -> selected.sketch
# 	inter.selected.points = -> selected.points
# 	inter.selected.edges = -> selected.edges

# 	#setters
# 	inter.select = {}
# 	inter.select.sketch = (sketch)-> selected.sketch = sketch
# 	inter.select.point = (point)-> selected.points.push point
# 	inter.select.edge = (edge)-> selected.edges.push edge

# 	###Hover data###
# 	hovered =
# 		points: []
# 		edges: []

# 	#getters
# 	inter.hovered = {}
# 	inter.hovered.points = -> hovered.points
# 	inter.hovered.edges = -> hovered.edges

# 	#setters
# 	inter.hover = {}
# 	inter.hover.point = (point)-> hovered.points.push point
# 	inter.unhover = ->
# 		hovered.points.length = 0
# 		hovered.edges.length = 0

# 	###Push up the interface###
# 	return inter

module.exports = new class Context
	constructor: ->
		@selected =
			sketch: undefined
			points: []
			edges: []

		@hovered =
			points: []
			edges: []

		#Convenience accessors
		@select =
			sketch: @select_sketch
			points: @select_point
			edges: @select_edge

		@hover =
			point: @hover_point
			edge: @hover_edge

	select_sketch: (sketch)=>
		@selected.sketch = sketch

	select_point: (point)=>
		@selected.points.push point

	select_edge: (edge)=>
		@selected.edges.push edge

	hover_point: (point)=>
		@hovered.points.push point

	hover_edge: (edge)=>
		@hovered.edges.push edge

	unhover: =>
		#Iterate over all hovered collections and reset them
		for n,collection of @hovered
			collection.length = 0