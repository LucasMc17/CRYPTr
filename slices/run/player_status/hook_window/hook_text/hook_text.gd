extends PanelContainer

## Whether or not the config controls should be exposed to the player. Trickles down to all child hook_function_label scenes.
@export var allow_config := false
## The Hook this is the full text of.
@export var hook : Hook

## The Function Label scene for instantiation during refresh.
var function_label_scene = preload('./hook_function_label.tscn')

@onready var hook_name := %HookName
@onready var no_func_label := %NoFuncLabel
@onready var function_holder := %FunctionHolder

func _ready():
	Events.refresh_hooks.connect(_on_hooks_updated)


## Refresh the text when the details of the Hook changes.
func refresh_text() -> void:
	no_func_label.visible = false
	for child in function_holder.get_children():
		child.queue_free()
	if !hook:
		hook_name.text = ""
		return
	else:
		hook_name.text = hook.hook_name
		if !hook.functions.is_empty():
			for function in hook.functions:
				var label = function_label_scene.instantiate()
				label.function = function
				label.allow_config = allow_config
				function_holder.add_child(label)
		else:
			no_func_label.visible = true


func _on_hooks_updated():
	refresh_text()
