test = require 'tape'
_ = require 'underscore'
$ = require 'jquery'

test 'got my libs?', (t)->
	t.plan 1
	console.log "#{$}"
	t.equal typeof $.ajax, 'function'

test 'got my underscore?', (t) ->
	t.plan 1
	t.equal typeof _.each, 'function'