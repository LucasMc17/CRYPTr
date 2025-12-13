extends GridContainer

var cryptograph_scene = preload("res://scenes/cryptograph.tscn")

## Clear out the grid, and then fill with cryptographs from provided array of resources.
func initialize(stack : Array[CryptographRes]) -> void:
	var stack_to_use = stack.duplicate()
	stack_to_use.sort_custom(func (a, b) -> bool: return a.letter.character < b.letter.character)

	for child in get_children():
		child.queue_free()
	
	for cryptograph in stack_to_use:
		var scene = cryptograph_scene.instantiate()
		scene.resource = cryptograph
		add_child(scene)