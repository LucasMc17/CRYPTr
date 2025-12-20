extends Switchable

func _on_new_run_button_pressed():
	Events.emit_new_run_started()