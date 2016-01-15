context = require '../app/assets/coffee/context'
Point = require '../app/assets/coffee/point'
assert = require 'assert'


describe 'context', ->
	it 'should select nodes and report them', ->
		context.select.point new Point(0,0)
		assert context.selected.points.length is zero