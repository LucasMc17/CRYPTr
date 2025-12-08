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


func _unhandled_input(_event):
	if Input.is_action_just_pressed("escape"):
		if paused:
			_pause_switcher.clear()
			paused = false
		else:
			_pause_switcher.transition('Pause')
			paused = true


func _on_match_started(encounter) -> void:
	_run_switcher.transition('Encounter', {"encounter": encounter})


func _on_map_returned(new_map := false) -> void:
	_run_switcher.transition('Map', { "new_map": new_map })


func setup(init_obj := {}) -> void:
	super(init_obj)
	if DebugNode.force_stack:
		Player.initialize_stack(DebugNode.force_stack)
	else:
		Player.initialize_stack(_classic_stack)