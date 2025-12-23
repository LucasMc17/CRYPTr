extends Node

@warning_ignore_start("unused_signal")

class ParamsObject:
	## System time of the event.
	var time : String
	## Event name.
	var event : String
	# TODO: clean this up witha a default version that adds ALL properties to dictionary.
	## Utility Callable to convert the resource to a Dictionary for printing purposes.
	var to_dictionary : Callable = DebugNode.make_to_printable_method(self, [
			"time",
			"letter",
			"encounter",
			"new_map",
			"menu_screen",
			"cryptograph_scene",
			"remaining_discards",
			"word",
			"types",
			"attempts_remaining"
	])

	func _init(param_event : String):
		time = Time.get_time_string_from_system()
		event = param_event
		DebugNode.print_n(event)
		DebugNode.print_h(to_dictionary.call())

# RUN LIFECYCLE

## Emitted when the player clicks the new run button
signal new_run_started(params : ParamsObject)
func emit_new_run_started():
	new_run_started.emit(ParamsObject.new('NEW RUN STARTED'))


## Emitted when the player clicks into a new match from the map screen.
signal match_started(params : MatchStartedParams)
class MatchStartedParams extends ParamsObject:
	var encounter : EncounterRes

	func _init(param_event : String, param_encounter : EncounterRes):
		encounter = param_encounter
		super(param_event)
func emit_match_started(encounter : EncounterRes):
	match_started.emit(MatchStartedParams.new("MATCH STARTED", encounter))


## Emitted when the player wins a match, typically combined with return_to_map
signal match_won(params: ParamsObject)
func emit_match_won():
	match_won.emit(ParamsObject.new("MATCH WON"))


## Emitted when the player leaves an encounter and returns to the map.
signal return_to_map(params : ReturnToMapParams)
class ReturnToMapParams extends ParamsObject:
	var new_map : bool

	func _init(param_event : String, param_new_map : bool):
		new_map = param_new_map
		super(param_event)
func emit_return_to_map(new_map : bool):
	return_to_map.emit(ReturnToMapParams.new("RETURN TO MAP", new_map))


## Emitted when a match is lost, forfeiting the run
signal run_lost(params : ParamsObject)
func emit_run_lost():
	run_lost.emit(ParamsObject.new("RUN LOST"))


## Emitted when a run is paused.
signal paused(params : PausedParams)
class PausedParams extends ParamsObject:
	var menu_screen : StringName

	func _init(param_event : String, param_menu_screen : StringName):
		menu_screen = param_menu_screen
		super(param_event)
func emit_paused(menu_screen : StringName = "Menu"):
	paused.emit(PausedParams.new("PAUSED", menu_screen))


## Emitted when a run is unpaused
signal unpaused(params: ParamsObject)
func emit_unpaused():
	unpaused.emit(ParamsObject.new("UNPAUSED"))


## Emitted when the user elects to quit to the main menu of the game.
signal quit_to_menu(params : ParamsObject)
func emit_quit_to_menu():
	quit_to_menu.emit(ParamsObject.new("QUIT TO MENU"))

# ENCOUNTER LIFECYCLE

## Emitted when the user left clicks on a cryptograph.
signal cryptograph_discarded(params : CryptographDiscardedParams)
class CryptographDiscardedParams extends ParamsObject:
	var cryptograph_scene : Cryptograph
	var remaining_discards : int
	var letter : String

	func _init(param_event : String, param_cryptograph_scene : Cryptograph, param_remaining_discards: int, param_letter : String):
		cryptograph_scene = param_cryptograph_scene
		remaining_discards = param_remaining_discards
		letter = param_letter
		super(param_event)
func emit_cryptograph_discarded(cryptograph_scene : Cryptograph, remaining_discards: int, letter : String):
	cryptograph_discarded.emit(CryptographDiscardedParams.new("CRYPTOGRAPH DISCARDED", cryptograph_scene, remaining_discards, letter))

## Emitted on each letter of the scored word in sequence.
signal letter_scored(params : LetterScoredParams)
class LetterScoredParams extends ParamsObject:
	var letter : StringName

	func _init(param_event : String, param_letter: StringName):
		letter = param_letter
		super(param_event)
func emit_letter_scored(letter : StringName):
	letter_scored.emit(LetterScoredParams.new("LETTER SCORED", letter))

## Emitted when a valid word is scored.
signal word_scored(params : WordScoredParams)
class WordScoredParams extends ParamsObject:
	var word : String
	var types : Dictionary[StringName, float]
	var attempts_remaining : int

	func _init(param_event : String, param_word : String, param_types : Dictionary[StringName, float], param_attempts_remaining : int):
		word = param_word
		types = param_types
		attempts_remaining = param_attempts_remaining
		super(param_event)
func emit_word_scored(word : String, types : Dictionary[StringName, float], attempts_left : int):
	word_scored.emit(WordScoredParams.new("WORD SCORED", word, types, attempts_left))

# SUBPROCESS EFFECTS

## Emitted when a subprocess triggers a score addition.
signal subprocess_addition(adder : int)

## Emitted when a subprocess triggers a score multiplier.
signal subprocess_multiplication(multiplier : float)

# DEBUG COMMANDS

## Emitted when the help command is issued
signal command_help(params : Array[String])

## Emitted when the echo command is issued
signal command_echo(params : Array[String])

## Emitted when the win command is issued
signal command_win(params : Array[String])

## Emitted when the lose command is issued
signal command_lose(params : Array[String])

## Emitted when the clear command is issued
signal command_clear(params : Array[String])

## Emitted when the exit command is issued
signal command_exit(params : Array[String])

## Emitted when the restart command is issued
signal command_restart(params : Array[String])