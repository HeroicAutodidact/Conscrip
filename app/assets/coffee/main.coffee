#Core modules are loaded
DrawWindow = require './drawWindow'
SketchData = require './sketchdata'
context = require './context'
ops = require './operations'
# KeyMap = require './keymap'
bindkeys = require './bindKeys'
bindkeys.linkOps ops
defaultkeymap = require './defaultkeymap'

##Linking procedure
ops.context = context
console.log ops
# KeyMap.linkOps ops


# defaultKeymap = require './defaultkeymap'
# context.keymap = defaultKeymap
# defaultKeymap.ops = ops

###TEST###
Node = require './node'


CoffeeScriptBrowser = require 'coffee-script-browser'
ceval = CoffeeScriptBrowser.eval
# CoffeeCompiler = require 'coffee-compiler'
#codeWindow = require './codeWindow.coffee'
#sketchOperations = require './sketchOperations.coffee'
#mouseHandle = require './mouseHandle.coffee'
#settingsManager = require './settingsManager.coffee'

dwin = undefined

mainLoop = ->
	do dwin.draw
	window.requestAnimationFrame(mainLoop)

window.onload = ->
	#This is just drafting, so we'll just create a single instance of
	#SketchData
	sketchdata = new SketchData
	context.selectSketch sketchdata
	dwin = new DrawWindow sketchdata, context
	dwin.attach()

	#Bind keys
	bindkeys defaultkeymap


	###TEST###
	sketchdata.nodes.push(new Node(10,10))
	#ceval 'alert "fun"' #Apparently I can evaluate coffeescript like this
	###ENDTEST###

	###Main loop###
	do mainLoop

###Scratch###


