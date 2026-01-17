class_name UISwitcher
extends Control
## Custom Control node for loading and unloading scenes from a list of potential children.
##
## Works by storing a dictionary of `Switchable` scenes and instantiating only a single child `Switchable` scene at a time. The `transition`
## method can be used to switch from the current child to another. This was designed to replace previous, more naive systems which only toggled the visibility of
## their children, instead of completely unloading them.

## Emitted when the Switcher transitions to a new scene.
signal transitioned(new_scene : String)

## The total list of `Switchable` scenes which this `UISwitcher` instance will be able to switch between.
@export var _scenes : Dictionary[String, PackedScene]
## StringName representing the current `Switchable` to be rendered as the only child of the scene. Must correspond to a key in the `_scenes` dictionary or the transition function will not run.
@export var current_scene : StringName

func _ready():
	if current_scene and _scenes.has(current_scene):
		var scene = _scenes[current_scene].instantiate()
		scene.parent_switcher = self
		scene.setup()
		add_child(scene)


## Swaps from the currently displayed scene to the scene specified by the `new_scene_name` parameter.
func transition(new_scene_name: StringName, ext := {}) -> void:
	if _scenes.has(new_scene_name):
		current_scene = new_scene_name
		var scene = _scenes[new_scene_name].instantiate()
		scene.parent_switcher = self
		scene.setup(ext)
		for child in get_children():
			child.queue_free()
		add_child(scene)
		transitioned.emit(new_scene_name)


## Removes the current switchable scene entirely, leaving no children under the ui switcher.
func clear() -> void:
	current_scene = ''
	for child in get_children():
		child.queue_free()
