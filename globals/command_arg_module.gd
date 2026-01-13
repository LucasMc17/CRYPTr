class_name CommandArgumentModule
extends Resource
## Logic module for reading and interpreting command line arguments for debug purposes.

## The full command string passed to the engine to start the game process.
var _arguments : PackedStringArray

## True if a debug process which forces a specific state has launched the program, such as `Debug Encounter` or `Debug Map`.
var is_debug_instance : bool

## True if process was started via `Debug Encounter` command.
var is_debug_encounter : bool

## True if process was started via `Debug Map` command.
var is_debug_map : bool

func _init():
	_arguments = OS.get_cmdline_args()
	is_debug_instance = '--debug-slice' in _arguments
	if is_debug_instance:
		is_debug_encounter = '--debug-encounter' in _arguments
		is_debug_map = '--debug-map' in _arguments
	else :
		is_debug_encounter = false
		is_debug_map = false