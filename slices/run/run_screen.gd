extends Switchable
## The main Switchable for the run itself, directly housing the run's UI Switcher and the pause UI Switcher.

# NOTE: directly loading the classic stack this way is a temporary solution until choosing a deck is integrated into the UI
var _classic_stack = preload("res://resources/starter_decks/the_classic.tres")

@onready var PAUSE_SWITCHER := %PauseSwitcher
@onready var RUN_SWITCHER := %RunSwitcher

func _on_match_started(_encounter) -> void:
	RUN_SWITCHER.transition('Encounter')


func _on_map_returned(new_map := false) -> void:
	RUN_SWITCHER.transition('Map', { "new_map": new_map })


func _ready():
	Events.match_started.connect(_on_match_started)
	Events.return_to_map.connect(_on_map_returned)


func setup(init_obj := {}) -> void:
	super(init_obj)
	if DebugNode.FORCE_STACK:
		Player.initialize_stack(DebugNode.FORCE_STACK)
	else:
		Player.initialize_stack(_classic_stack)