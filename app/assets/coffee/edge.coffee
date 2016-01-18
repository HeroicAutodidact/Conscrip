module.exports = class Edge
	constructor: (sp, ep)->
		@sp = sp
		@ep = ep

	equals: (otheredge)=>
		if @sp is otheredge.sp and @ep is otheredge.ep
			return true
		if @sp is otheredge.ep and @sp is otheredge.sp
			return true
		else
			return false