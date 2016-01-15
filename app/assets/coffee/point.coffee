HTOL = 5

Point = (x,y)->
	@x = x
	@y = y
	return

Point::is_hovered_by = (mousepos)->
	return true if Math.abs(@x - mousepos[0])< HTOL and Math.abs(@y - mousepos[1])<HTOL

module.exports = Point