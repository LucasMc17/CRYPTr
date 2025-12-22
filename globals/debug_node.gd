extends Node
## Debug overrides and logic.

@export_category("Master Override")
## Master debug override. When enabled, overrides all options in the "Overrides" category below.
@export var god_mode := false

@export_category("Overrides")
## Consider all letter inputs as valid, regardless of whether they are currently in hand.
@export var accept_all_letters := false:
	get():
		return _check_overrides(accept_all_letters)
## Consider all word inputs as valid without checking against in game dictionary.
@export var accept_all_words := false:
	get():
		return _check_overrides(accept_all_words)
## Consider the current encounter won after next word input, regardless of score.
@export var instawin := false:
	get():
		return _check_overrides(instawin)

@export_category("Inventory")
## Force a particular starter stack for testing purposes.
@export var force_stack : StarterStack

@export_category("Logging")
## Degree of frequency of console logging.
@export_enum("NONE", "NORMAL", "HIGH") var log_level := 0

## the game's debug console.
var debug_console : DebugConsole
## Preloaded debug ui packed scene for initialization.
var _debug_ui = preload('res://scenes/debug_ui/debug_ui.tscn')

func _ready():
	var root = get_tree().current_scene
	root.add_child(_debug_ui.instantiate())


## Utility method for checking the `god_mode` override before checking the value itself.
func _check_overrides(value):
	if god_mode:
		return true
	else:
		return value


## Print method for logging information to the debug console from this global node.
func print(message):
	if debug_console:
		debug_console.log(message)


## Method for arbitrarily logging for debug purposes.
func p(message):
	DebugNode.print(message)


## Prints the message only if log level is NORMAL or higher.
func print_n(message):
	if log_level > 0:
		DebugNode.print(message)


## Prints the message only if log level is HIGH.
func print_h(message):
	if log_level > 1:
		DebugNode.print(message)


## Factory function for creating printable format of complex objects.
func make_to_printable_method(entity, params := []) -> Callable:
	return func(expand_children := false) -> Dictionary:
		var result := {}
		for param in params:
			if param in entity:
				if expand_children and entity[param] is Object and "to_dictionary" in entity[param]:
					result[param] = entity[param].to_dictionary.call()
				else:
					result[param] = entity[param]
		
		return result