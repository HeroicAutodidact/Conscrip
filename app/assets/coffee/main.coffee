drawWindow = require './drawWindow.coffee'
#codeWindow = require './codeWindow.coffee'
#sketchOperations = require './sketchOperations.coffee'
#mouseHandle = require './mouseHandle.coffee'
#keymap = require './defaultKeymap.coffee'
#settingsManager = require './settingsManager.coffee'

window.onload = ->
	dwin = new drawWindow
	dwin.attach()
	dwin._drawNode({x:20,y:20})