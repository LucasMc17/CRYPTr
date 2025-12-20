extends Switchable
## The main menu of the pause screen, with buttons for switching to most other views.

func _on_resume_button_pressed():
	Events.emit_unpaused()


func _on_stack_button_pressed():
	parent_switcher.transition("Stack")


func _on_quit_button_pressed():
	Events.emit_unpaused()
	Events.emit_quit_to_menu()