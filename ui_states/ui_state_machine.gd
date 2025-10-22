class_name UIStateMachine extends Control

@export var DISABLED := false
@export var CURRENT_STATE : UIState

var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is UIState:
			states[child.name] = child
			child.transitioned.connect(on_child_transitioned)
		else:
			push_warning("State machine contains incompatible child node")
	if owner:
		await owner.ready
	if !DISABLED:
		CURRENT_STATE.enter(null, {})

func _input(event):
	if !DISABLED:
		CURRENT_STATE.input(event)

func _process(delta):
	if !DISABLED:
		CURRENT_STATE.update(delta)
	# Global.debug.add_property("Current State", CURRENT_STATE.name, 1)

func _physics_process(delta):
	if !DISABLED:
		CURRENT_STATE.physics_update(delta)

func on_child_transitioned(new_state_name: StringName, ext : Dictionary):
	if !DISABLED:
		var new_state = states.get(new_state_name)
		if new_state != null and new_state != CURRENT_STATE:
			CURRENT_STATE.exit()
			new_state.enter(CURRENT_STATE, ext)
			CURRENT_STATE = new_state

func lock():
	DISABLED = true

func unlock():
	DISABLED = false
