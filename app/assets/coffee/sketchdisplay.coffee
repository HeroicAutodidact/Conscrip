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

sketchDisplay::clear = (ctx)->
	ctx.save()
	ctx.fillStyle = '#DDDDDD'#'rgb(#{255},#{255},#{255})'
	ctx.fillRect 0,0,@_canvas.width, @_canvas.height
	ctx.restore()

sketchDisplay::draw = ->
	@clear @c
	for protocol in @getProtocols()
		protocol.apply @


###Some drawing methods included by default###

drawPoint = (ctx,point)->
	ctx.save()
	ctx.beginPath()
	radius = settings.pointSize
	ctx.arc(point.x,point.y,radius,0,2*Math.PI)
	ctx.strokeStyle = settings.pointColor
	ctx.lineWidth = Math.floor radius / 2
	ctx.stroke()
	ctx.closePath()
	ctx.restore()


hover_highlight = (ctx, point)->
	ctx.save()
	ctx.beginPath()
	radius = settings.pointSize * 2
	ctx.arc(point.x,point.y,radius,0,2*Math.PI)
	ctx.strokeStyle = settings.pointColor
	ctx.lineWidth = Math.floor radius / 2
	ctx.stroke()
	ctx.closePath()
	ctx.restore()


#Establishes aesthetic defaults and all drawing protocols to be run through
defaultSettings =
	{
		pointSize: 2
		pointColor: '#888888'
		protocols:
			{
				drawAllPoints: ->
					for point in @sketchdata.points
						drawPoint @c, point
				highlightHoveredPoints: ->
					for point in @context.hovered.points
						hover_highlight @c, point
			}
	}
#Loads in a clone of default settings and creates a handle 'settings'
settings = sketchDisplay.settings = $.extend {}, defaultSettings



module.exports = sketchDisplay