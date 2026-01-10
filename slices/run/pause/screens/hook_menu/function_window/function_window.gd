extends PanelContainer

## The function summary scene for instantiation.
static var function_summary = preload("./function_summary.tscn")

@onready var function_holder := %FunctionHolder

## Populates the function window with all the player's functions.
func populate():
	for child in function_holder.get_children():
		child.queue_free()
	for function : Function in Player.functions:
		var scene = function_summary.instantiate()
		scene.function = function
		function_holder.add_child(scene)


## Refreshes each Function Summary scene by updating its currently selected hook and colors.
func refresh(hook : Hook):
	for child in function_holder.get_children():
		child.populate(hook)