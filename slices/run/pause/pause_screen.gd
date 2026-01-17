extends Switchable
## The Pause screen of the run slice of the game.

## Menu states which should not expose the back button.
const NO_BACK_BUTTON := ["Menu"]

## The sub menu of the pause screen to initiate the pause menu with.
var starting_menu := "Menu"

@onready var _pause_menu_switcher := %PauseMenuSwitcher

@onready var back_button_holder := %BackButtonHolder

func _ready():
	_pause_menu_switcher.transition(starting_menu)


func setup(init_obj := {}) -> void:
	if init_obj.has("menu_screen"):
		starting_menu = init_obj.menu_screen
	super(init_obj)


func _on_back_button_pressed():
	_pause_menu_switcher.transition("Menu")

func _on_pause_menu_switcher_transitioned(new_scene : String):
	back_button_holder.visible = !NO_BACK_BUTTON.has(new_scene)