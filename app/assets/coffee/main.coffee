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

CoffeeScriptBrowser = require 'coffee-script-browser'
ceval = CoffeeScriptBrowser.eval
# CoffeeCompiler = require 'coffee-compiler'
#codeWindow = require './codeWindow.coffee'
#sketchOperations = require './sketchOperations.coffee'
#mouseHandle = require './mouseHandle.coffee'
#settingsManager = require './settingsManager.coffee'

sdisplay = undefined

mainLoop = ->
	do sdisplay.draw
	window.requestAnimationFrame(mainLoop)

window.onload = ->
	#We'll just create a single instance of
	#SketchData
	sketchdata = new SketchData
	context.select.sketch sketchdata
	sdisplay = new SketchDisplay sketchdata, context
	sdisplay.attach()

	###TEMPORARY, THIS SHOULD BE MOVED TO THE LINKING PROCEDURE SECTION###
	#In the future, dsdisplay acts as a buffer which is drawn to a central canvas.
	context.display = sdisplay.canvas
	mousehandle.link_context context
	###END TEMPORARY###

	#Bind keys
	bindkeys defaultkeymap


	###TEST###
	#ceval 'alert "fun"' #Apparently I can evaluate coffeescript like this
	###ENDTEST###

	###Main loop###
	do mainLoop

###Scratch###


