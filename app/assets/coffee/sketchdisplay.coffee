display_protocols = require './display_protocols'
$ = require 'jquery'
_ = require 'lodash'

module.exports = class SketchDisplay
	constructor: (sketchdata, context)->
		@canvas = document.createElement('canvas')
		@canvas.height = 500
		@canvas.width = 500
		@canvas.id = 'ConscriptDispaly'
		@ctx = @canvas.getContext '2d'
		@context = context
		console.log context
		@protocols = {}
		for name,dp of display_protocols
			@protocols[name] = dp.bind @
			@protocols[name].pname = name #attach the name to the protocol for easy access
		@active_protocols = []
		@activate_protocols ['clear','drawAllPoints','highlightHoveredPoints']

	attach: (parentElement)->
		if parentElement?
			parentElement.appendChild(@canvas)
		else
			document.body.appendChild(@canvas)
		return

	offset: =>
		#Necessary for other modules to understand the displays place in space
		$(@canvas).offset()

	activate_protocols: (pnames)=>
		@activate_protocols = {}
		for pname in pnames
			protocol = _.find @protocols, (pro)-> return pro.pname is pname
			@active_protocols.push protocol

	draw: =>
		for protocol in @active_protocols
			do protocol
