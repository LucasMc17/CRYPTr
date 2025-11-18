class_name UISwitcher extends Control

@export var SCENES : Dictionary[String, PackedScene]


@export var CURRENT_SCENE : StringName

func _ready():
	if CURRENT_SCENE and SCENES.has(CURRENT_SCENE):
		var scene = SCENES[CURRENT_SCENE].instantiate()
		scene.setup()
		add_child(scene)

## This function swaps from the currently displayed scene to the scene specified by the new_scene_name parameter.
func transition(new_scene_name: StringName, ext := {}) -> void:
	if SCENES.has(new_scene_name):
		CURRENT_SCENE = new_scene_name
		var scene = SCENES[new_scene_name].instantiate()
		scene.setup(ext)
		for child in get_children():
			child.queue_free()
		add_child(scene)

