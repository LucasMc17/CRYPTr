extends Control

## The index of this Hook Preview within the list of Player hooks.
@export var index := 0

## The hook which this Preview represents. On change, the text of the label should update, and the HookText should refresh.
var hook : Hook:
	set(val):
		if val and name_label:
			name_label.text = val.hook_name
		hook_text.hook = val
		hook_text.refresh_text()
		hook = val

@onready var index_label = %Index
@onready var name_label = %HookName
@onready var hook_text = %HookText

func _ready():
	index_label.text = str(index) + ":"
	if Player.hooks.size() > index:
		hook = Player.hooks[index]
	else:
		hook = null


func _on_h_box_container_mouse_entered():
	if hook:
		hook_text.visible = true


func _on_h_box_container_mouse_exited():
	hook_text.visible = false