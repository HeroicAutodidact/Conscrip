module.exports = do ->
	canvas_pos = [undefined, undefined]
	context = undefined #Must be explicitly linked for module to function properly
	inter = {} #What will be returned for accessing this module publically

	inter.position = -> canvas_pos

	inter.link_context = (newcontext)->
		context = newcontext

		###Should work fine when the sketchdisplay is a simple canvas###
		context.display.onmousemove = (e)->
			###Update mouse position###
			canvas_pos[0] = e.clientX - context.display.getBoundingClientRect().left
			canvas_pos[1] = e.clientY - context.display.getBoundingClientRect().top

			###Update hovered###
			do context.unhover
			for p in context.selected.sketch.points
				context.hover.point p if p.is_hovered_by inter.position()

	return inter #Send up the interface for public access
