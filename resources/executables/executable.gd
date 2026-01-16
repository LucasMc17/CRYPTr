class_name Executable
extends Resource
## Custom resource representing an Executable, a one-time use consumable which offers benefits to the player.
## 
## Has a list of applicable game states as well as a `run` func for firing effects, which are defined in executables inheriting from this class.

## The Executable's name.
@export var executable_name : String
## The rarity of the Executable.
@export_enum("COMMON", "RARE", "EPIC") var rarity = 0
## A brief description of the Executable's utility.
@export_multiline var description : String

## Which game states this encounter can be used during.
@export_group("Applicable Game States", "applicable_to_")
## if True, usable from Map state.
@export var applicable_to_map := true
## if True, usable from Encounter state.
@export var applicable_to_encounter := true
## if True, usable from Shop state.
@export var applicable_to_shop := true

## Dollar value of executable (only relevant for investment.exe)
var value := 0

static var applicability_map = {
	"dot_dot": func () -> bool:
		return !!Player.current_encounter and !!Player.current_encounter.parent,
	"cache_buster": func () -> bool:
		return !Player.current_stack.is_empty()
}

## Executes the function.
func _execute() -> void:
	Player.remove_executable(self)
	Events.refresh_hooks.emit()
	if executable_name == "investment":
		Events.investment_executed.emit(value)
	else:
		var signal_name = executable_name + "_executed"
		if Events.has_signal(signal_name):
			Events[signal_name].emit()
		else:
			push_warning("WARNING: No signal for executable with name " + executable_name)


## Returns true if the Executable can currently be ran.
func get_applicability() -> bool:
	var variable_name = "applicable_to_" + Player.game_state
	if !self[variable_name]:
		return false
	if !executable_name in applicability_map:
		return true
	return applicability_map[executable_name].call()


## Run the executable, if able.
func run() -> void:
	if get_applicability():
		_execute()