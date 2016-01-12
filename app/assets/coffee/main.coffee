DrawWindow = require './drawWindow'
SketchData = require './sketchdata'
Context = require './context'
ops = require './operations'

###TEST###
Node = require './node'


CoffeeScriptBrowser = require 'coffee-script-browser'
ceval = CoffeeScriptBrowser.eval
# CoffeeCompiler = require 'coffee-compiler'
#codeWindow = require './codeWindow.coffee'
#sketchOperations = require './sketchOperations.coffee'
#mouseHandle = require './mouseHandle.coffee'
keymap = require './defaultKeymap.coffee'
#settingsManager = require './settingsManager.coffee'

dwin = undefined

mainLoop = ->
	do dwin.draw
	window.requestAnimationFrame(mainLoop)

window.onload = ->
	sketchdata = new SketchData
	context = new Context
	dwin = new DrawWindow sketchdata, context
	dwin.attach()


	###TEST###
	sketchdata.nodes.push(new Node(10,10))
	#ceval 'alert "fun"' #Apparently I can evaluate coffeescript like this
	###ENDTEST###

	###Main loop###
	do mainLoop

###Scratch###


