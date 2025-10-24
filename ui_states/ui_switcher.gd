class_name UISwitcher extends Control

@export var SCENES : Dictionary[StringName, PackedScene]

@export var CURRENT_SCENE : StringName

func _ready():
	if CURRENT_SCENE and SCENES.has(CURRENT_SCENE):
		var scene = SCENES[CURRENT_SCENE].instantiate()
		add_child(scene)

func transition(new_scene_name: StringName, ext := {}) -> void:
	if SCENES.has(new_scene_name):
		CURRENT_SCENE = new_scene_name
		var scene = SCENES[new_scene_name].instantiate()
		if scene.has_method("setup"):
			scene.setup(ext)
		for child in get_children():
			child.queue_free()
		add_child(scene)

