extends Switchable
## The main Switchable for the run itself, directly housing the run's UI Switcher and the pause UI Switcher.

# NOTE: directly loading the classic stack this way is a temporary solution until choosing a deck is integrated into the UI
var _classic_stack = preload("res://resources/starter_decks/the_classic.tres")
## Boolean tracking whether or not the game is currently paused. Probably not going to stay here.
var paused := false

@onready var _pause_switcher := %PauseSwitcher
@onready var _run_switcher := %RunSwitcher

func _ready():
	Events.match_started.connect(_on_match_started)
	Events.return_to_map.connect(_on_map_returned)
	Events.paused.connect(_on_run_paused)
	Events.unpaused.connect(_on_run_unpaused)


func _unhandled_input(_event):
	if Input.is_action_just_pressed("escape"):
		if paused:
			Events.unpaused.emit()
			# _pause_switcher.clear()
		else:
			Events.paused.emit("Menu")


func _on_match_started(encounter) -> void:
	_run_switcher.transition('Encounter', {"encounter": encounter})


func _on_map_returned(new_map := false) -> void:
	_run_switcher.transition('Map', { "new_map": new_map })


func _on_run_paused(menu_screen : StringName) -> void:
	_pause_switcher.transition("Pause", {"starting_menu": menu_screen})
	paused = true


func _on_run_unpaused() -> void:
	_pause_switcher.clear()
	paused = false


func setup(init_obj := {}) -> void:
	super(init_obj)
	if DebugNode.force_stack:
		Player.initialize_stack(DebugNode.force_stack)
	else:
		Player.initialize_stack(_classic_stack)