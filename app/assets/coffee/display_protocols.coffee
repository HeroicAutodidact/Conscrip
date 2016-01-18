###
DRAWING HELPERS
###
pointColor = '#888888'
pointSize = 3
edgeThickness = 2

drawPoint = (ctx,point)->
	ctx.save()
	ctx.beginPath()
	radius = pointSize
	ctx.arc(point.x,point.y,radius,0,2*Math.PI,true)
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
	ctx.lineWidth = Math.floor radius / 4
	ctx.stroke()
	ctx.closePath()
	ctx.restore()

select_highlight = (ctx, point)->
	ctx.save()
	ctx.beginPath()
	radius = pointSize
	ctx.arc(point.x,point.y,radius,0,2*Math.PI)
	ctx.fillStyle = pointColor
	ctx.fill()
	ctx.closePath()
	ctx.restore()

drawEdge = (ctx, edge)->
	ctx.save()
	ctx.beginPath()
	ctx.lineWidth = edgeThickness
	ctx.strokeStyle = pointColor
	ctx.moveTo edge.sp.x, edge.sp.y
	ctx.lineTo edge.ep.x, edge.ep.y
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

	highlightSelectedPoints: ->
		for point in @context.selected.points
			select_highlight @ctx, point

	drawAllEdges: ->
		for edge in @context.selected.sketch.edges
			drawEdge @ctx, edge

	clear: ->
		@ctx.save()
		@ctx.fillStyle = '#DDDDDD'#'rgb(#{255},#{255},#{255})'
		@ctx.fillRect 0,0,@canvas.width, @canvas.height
		@ctx.restore()