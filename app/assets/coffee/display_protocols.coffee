###
DRAWING HELPERS
###
pointColor = '#888888'
pointSize = 2

drawPoint = (ctx,point)->
	ctx.save()
	ctx.beginPath()
	radius = pointSize
	ctx.arc(point.x,point.y,radius,0,2*Math.PI)
	ctx.strokeStyle = pointColor
	ctx.lineWidth = Math.floor radius / 2
	ctx.stroke()
	ctx.closePath()
	ctx.restore()


hover_highlight = (ctx, point)->
	ctx.save()
	ctx.beginPath()
	radius = pointSize * 2
	ctx.arc(point.x,point.y,radius,0,2*Math.PI)
	ctx.strokeStyle = pointColor
	ctx.lineWidth = Math.floor radius / 2
	ctx.stroke()
	ctx.closePath()
	ctx.restore()


###PROTOCOLS###
module.exports =
	drawAllPoints: ->
		for point in @context.selected.sketch.points
			drawPoint @ctx, point

	highlightHoveredPoints: ->
		for point in @context.hovered.points
			hover_highlight @ctx, point

	clear: ->
		@ctx.save()
		@ctx.fillStyle = '#DDDDDD'#'rgb(#{255},#{255},#{255})'
		@ctx.fillRect 0,0,@canvas.width, @canvas.height
		@ctx.restore()