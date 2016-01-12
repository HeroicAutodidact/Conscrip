Context = ->
	selectedSketch = undefined
	return

Context::selectSketch = (sketch)->
	selectedSketch = sketch
	return

module.exports = Context