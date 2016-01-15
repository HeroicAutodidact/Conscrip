canvas_pos = [undefined, undefined]

mousehandle =
	context: undefined #Must be explicitly linked for module to function properly
	link_context: (context)->
		@context = context
		###Should work fine when the sketchdisplay is a simple canvas###
		context.display.onmousemove = (e)->
			canvas_pos[0] = e.clientX - context.display.getBoundingClientRect().left
			canvas_pos[1] = e.clientY - context.display.getBoundingClientRect().top
	position: -> canvas_pos

module.exports = mousehandle