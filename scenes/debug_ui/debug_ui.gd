extends VBoxContainer

func _unhandled_input(_event):
	if Input.is_action_just_pressed("toggle_debug"):
		visible = !visible