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
			Events.emit_unpaused()
		else:
			Events.emit_paused()


func _on_match_started(params : Events.MatchStartedParams) -> void:
	var encounter = params.encounter
	_run_switcher.transition('Encounter', {"encounter": encounter})


func _on_map_returned(params : Events.ReturnToMapParams) -> void:
	_run_switcher.transition('Map', {"new_map": params.new_map})


func _on_run_paused(params : Events.PausedParams) -> void:
	_pause_switcher.transition("Pause", {"menu_screen": params.menu_screen})
	paused = true
	get_tree().paused = true


func _on_run_unpaused(_params) -> void:
	_pause_switcher.clear()
	paused = false
	get_tree().paused = false


func setup(init_obj := {}) -> void:
	super(init_obj)
	Player.hooks = DebugNode.force_hooks.map(func(hook): return hook.duplicate())
	Player.functions = DebugNode.force_functions.map(func(function): return function.duplicate())
	if DebugNode.force_stack:
		Player.initialize_stack(DebugNode.force_stack)
	else:
		Player.initialize_stack(_classic_stack)