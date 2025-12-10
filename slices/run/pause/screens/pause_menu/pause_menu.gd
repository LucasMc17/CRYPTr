extends Switchable
## The main menu of the pause screen, with buttons for switching to most other views.

@onready var _resume_button := %ResumeButton
@onready var _stack_button := %StackButton
@onready var _settings_button := %SettingsButton
@onready var _quit_button := %QuitButton

func _on_resume_button_pressed():
	Events.unpaused.emit()


func _on_stack_button_pressed():
	parent_switcher.transition("Stack")