#Core modules are loaded
SketchDisplay = require './sketchdisplay'
SketchData = require './sketchdata'
context = require './context'
ops = require './operations'
# KeyMap = require './keymap'
bindkeys = require './bindKeys'
defaultkeymap = require './defaultkeymap'
mousehandle = require './mousehandle'

##Linking procedure
ops.context = context
ops.mousehandle = mousehandle
bindkeys.linkOps ops

# KeyMap.linkOps ops



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
	dwin = new SketchDisplay sketchdata, context
	dwin.attach()

	###TEMPORARY, THIS SHOULD BE MOVED TO THE LINKING PROCEDURE SECTION###
	#In the future, ddwin acts as a buffer which is drawn to a central canvas.
	context.display = dwin._canvas
	mousehandle.link_context context
	###END TEMPORARY###

	#Bind keys
	bindkeys defaultkeymap


	###TEST###
	sketchdata.nodes.push(new Node(10,10))
	#ceval 'alert "fun"' #Apparently I can evaluate coffeescript like this
	###ENDTEST###

	###Main loop###
	do mainLoop

###Scratch###


