extends GridContainer

var cryptograph_scene = preload("res://scenes/cryptograph.tscn")

## Clear out the grid, and then fill with cryptographs from provided array of resources.
func initialize(stack : Array[CryptographRes]) -> void:
	for child in get_children():
		child.queue_free()
	
	for cryptograph in stack:
		var scene = cryptograph_scene.instantiate()
		scene.resource = cryptograph
		add_child(scene)