Context = ->
	selectedSketch = undefined
	keymap = undefined
	return

Context::selectSketch = (sketch)->
	selectedSketch = sketch
	return

module.exports = Context