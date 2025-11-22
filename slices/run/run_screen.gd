extends Switchable

@onready var PAUSE_SWITCHER := %PauseSwitcher
@onready var RUN_SWITCHER := %RunSwitcher

var CLASSIC_STACK = preload("res://resources/starter_decks/the_classic.tres")


func setup(init_obj := {}) -> void:
	super(init_obj)
	if DebugNode.FORCE_STACK:
		Player.initialize_stack(DebugNode.FORCE_STACK)
	else:
		Player.initialize_stack(CLASSIC_STACK)

func _on_match_started(_encounter):
	RUN_SWITCHER.transition('Encounter')

func _ready():
	Events.match_started.connect(_on_match_started)