test = require('tape')
tardball = require('../app/assets/coffee/app/tardball.coffee')

test 'timing test', (t)->
	t.plan 1
	console.log("The following is tardball:")
	console.log(tardball)
	t.equal tardball, 111