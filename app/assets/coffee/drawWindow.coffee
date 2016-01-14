#Some utility modules
$ = require 'jquery'
_ = require 'lodash'
SketchData = require './sketchdata'


sketchDisplay = (sketchdata, context)->
	##This is the window which is be used to display sketches

	#Canvas setup
	@_canvas = document.createElement('canvas')
	@_canvas.height = 500
	@_canvas.width = 500
	@_canvas.id = 'conscriptDisplay'
	@c = @_canvas.getContext '2d'

	#Initialize all drawing protocols
	@_protocols = settings.protocols

	#Initialize the sketchdata object
	@sketchdata = sketchdata
	@context = context

	return


sketchDisplay::attach = (parentElement)->
	if parentElement?
		parentElement.appendChild(@_canvas)
	else
		document.body.appendChild(@_canvas)
	return

sketchDisplay::getProtocols = ->
	return _.values(@_protocols)

sketchDisplay::draw = ->
	for protocol in @getProtocols()
		protocol.apply @


###Some drawing methods included by default###

drawNode = (ctx,node)->
	ctx.save()
	ctx.beginPath()
	radius = settings.nodeSize
	ctx.arc(node.x,node.y,radius,0,2*Math.PI)
	ctx.strokeStyle = settings.nodeColor
	ctx.lineWidth = Math.floor radius / 2
	ctx.stroke()
	ctx.closePath()

#Establishes aesthetic defaults and all drawing protocols to be run through
defaultSettings =
	{
		nodeSize: 2
		nodeColor: '#888888'
		protocols:
			{
				drawAllNodes: ->
					for node in @sketchdata.nodes
						drawNode @c, node
			}
	}
#Loads in a clone of default settings and creates a handle 'settings'
settings = sketchDisplay.settings = $.extend {}, defaultSettings



module.exports = sketchDisplay