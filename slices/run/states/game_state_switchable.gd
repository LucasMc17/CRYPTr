class_name GameStateSwitchable
extends Switchable
## Switchable for use directly and only with the run screen UISwitcher. 
##
## Updated the Player's game state and triggers a check for applicability for all collected Executables.

## The game state name to update `Player.game_state` with.
@export var state_name : String

func setup(init_obj := {}) -> void:
	Player.game_state = state_name
	Events.refresh_executable_access.emit()
	super(init_obj)