Mousetrap = require 'mousetrap'
ops = undefined

bindkeys = (keyDict)->
	Mousetrap.reset()
	for kstr, fnstr of keyDict
		if not ops[fnstr]?
			throw Error "#{fnstr} isn't a function"
		else
			Mousetrap.bind kstr, ops[fnstr]
	# Mousetrap.bind 'a', ops['placePoint']
	# Mousetrap.bind 'g', ops['selectHovered']

bindkeys.linkOps = (newops)->
	ops = newops

module.exports = bindkeys