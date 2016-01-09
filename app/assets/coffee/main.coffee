DrawWindow = require './drawWindow'
SketchData = require './sketchdata'
Node = require './node'
#codeWindow = require './codeWindow.coffee'
#sketchOperations = require './sketchOperations.coffee'
#mouseHandle = require './mouseHandle.coffee'
#keymap = require './defaultKeymap.coffee'
#settingsManager = require './settingsManager.coffee'

dwin = undefined

mainLoop = ->
	do dwin.draw
	window.requestAnimationFrame(mainLoop)

window.onload = ->
	sketchdata = new SketchData
	dwin = new DrawWindow sketchdata
	dwin.attach()

	###TEST###
	sketchdata.nodes.push(new Node(10,10))
	###ENDTEST###

	###Main loop###
	do mainLoop


