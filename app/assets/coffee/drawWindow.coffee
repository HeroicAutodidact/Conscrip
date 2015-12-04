#Assumptions and standards

#Every module has its own settings
sketchDisplay.defaultSettings = {
	nodeSize: 3
	nodeColor: '#888888'
}

settings = sketchDisplay.settings = sketchDisplay.defaultSettings

sketchDisplay = ->
	##This is the window which is be used to display sketches
	@_canvas = document.createElement('canvas')
	@_canvas.height = 500
	@_canvas.width = 500
	@_canvas.id = 'conscriptDisplay'
	@c = @_canvas.getContext '2d'
	@_protocols = settings.protocols
	return


sketchDisplay::attach = (parentElement)->
	if parentElement?
		parentElement.appendChild(@_canvas)
	else
		document.body.appendChild(@_canvas)
	return

sketchDisplay::getProtocols = ->
	return Object.keys(@_protocols)


###Some drawing methods included by default###
drawNode = (node)->
	@c.save()
	@c.beginPath()
	radius = settings.nodeSize
	@c.arc(node.x,node.y,radius,0,2*Math.PI)
	@c.strokeStyle = settings.nodeColor
	@c.stroke()
	@c.closePath()



module.exports = sketchDisplay