ops = undefined

KeyMap = ->
	@_mapping = {}
	return

KeyMap::map = (key,fnName)->
	#Maps a key to an operation

	#Make sure that we have a reference to the operations library
	if not ops?
		throw Error 'ops is undefined in KeyMap module, was it properly linked?'

	#Makes sure that the function exists within the operations library
	if not ops[fnName]?
		throw Error 'No such operation, "#{fnName}"'

	#Associates the key with a call to the desired operation, executed within the
	#context of the operation library
	@_mapping[key] = ->
		do ops[fnName]
	return

KeyMap::fnFromKey = (key)->
	#Takes a string 'key' and returns an operation to perform
	return @_mapping[key]

KeyMap.linkOps = (newops)->
	ops = newops
	return

module.exports = KeyMap