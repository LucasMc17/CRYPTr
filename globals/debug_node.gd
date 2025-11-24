extends Node

var DEBUG_UI = preload('res://scenes/debug_ui/debug_ui.tscn')

func check_overrides(value):
	if GOD_MODE:
		return true
	else:
		return value

func print(message):
	if DEBUG_CONSOLE:
		DEBUG_CONSOLE.log(message)

@export_category("Master Override")
@export var GOD_MODE := false

@export_category("Overrides")
@export var ACCEPT_ALL_LETTERS := false:
	get():
		return check_overrides(ACCEPT_ALL_LETTERS)
@export var ACCEPT_ALL_WORDS := false:
	get():
		return check_overrides(ACCEPT_ALL_WORDS)
@export var INSTAWIN := false:
	get():
		return check_overrides(INSTAWIN)

@export var FORCE_STACK : StarterStack

var DEBUG_CONSOLE : DebugConsole

func _ready():
	var root = get_tree().current_scene
	root.add_child(DEBUG_UI.instantiate())
