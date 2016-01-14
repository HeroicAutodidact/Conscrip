Mousetrap = require 'mousetrap'
ops = undefined

bindkeys = (keyDict)->
	Mousetrap.reset()
	for kstr, fnstr of keyDict
		Mousetrap.bind kstr, ->
			do ops[fnstr]

bindkeys.linkOps = (newops)->
	ops = newops

module.exports = bindkeys