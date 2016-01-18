###
The tool class specifies the behavior and attribute of all 'tools' within
conscrip. When a tool is activated (when context.current_tool references a
given tool) a tool object will be responsible for specifying a new keymapping,
customized display protocols (i.e. display the line which would be created) and
the behavior of clicks.
###

module.exports = class Tool
	constructor: ->
		###
		Build button from icon or text if provided
		###

		#Set up all tool specific attributes
		@button = undefined
		@name = undefined
		@mod_map= {} #A mapping from modifier sets to operations


	activate: =>
		###
		The application is responsible for calling this method every time this tool
		is made the current active tool.

		This method activates the necessary display protocols and key mappings
		This method is also responsible for creating any state variables specific to
		this tool.
		###
		throw Error "activate method is not specified for #{name}"

	deactivate: =>
		###
		The application is responsible for calling deactivate when switching to a
		different tool.

		deactivate is responsible for resetting all state variables and deactivating
		display protocols and key bindings
		###
		throw Error "deactivate method is not specified for #{name}"

	handle_click: =>
		for modset in @mod_map
			###
			if Mousetrap.mods.sort is modset.sort

