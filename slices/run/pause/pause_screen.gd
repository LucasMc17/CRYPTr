extends Switchable
## The Pause screen of the run slice of the game.

## The sub menu of the pause screen to initiate the pause menu with.
var starting_menu := "Menu"

@onready var _pause_menu_switcher := %PauseMenuSwitcher

func _ready():
	_pause_menu_switcher.transition(starting_menu)


func setup(init_obj := {}) -> void:
	if init_obj.has("menu_screen"):
		starting_menu = init_obj.menu_screen
	super(init_obj)