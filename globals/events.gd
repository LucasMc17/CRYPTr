extends Node

@warning_ignore_start("unused_signal")

@abstract class ParamsObject:
	var time : String

	func _init():
		time = Time.get_time_string_from_system()

# RUN LIFECYCLE

## Emitted when the player clicks the new run button
signal new_run_started()
func emit_new_run_started():
	new_run_started.emit()


## Emitted when the player clicks into a new match from the map screen.
signal match_started(params : MatchStartedParams)
class MatchStartedParams extends ParamsObject:
	var encounter : EncounterRes

	func _init(param_encounter : EncounterRes):
		super()
		encounter = param_encounter
func emit_match_started(encounter : EncounterRes):
	match_started.emit(MatchStartedParams.new(encounter))


## Emitted when the player wins a match, typically combined with return_to_map
signal match_won()
func emit_match_won():
	match_won.emit()

## Emitted when the player leaves an encounter and returns to the map.
signal return_to_map(params : ReturnToMapParams)
class ReturnToMapParams extends ParamsObject:
	var new_map : bool

	func _init(param_new_map : bool):
		super()
		new_map = param_new_map
func emit_return_to_map(new_map : bool):
	return_to_map.emit(ReturnToMapParams.new(new_map))

## Emitted when a match is lost, forfeiting the run
signal run_lost()
func emit_run_lost():
	run_lost.emit()

## Emitted when a run is paused.
signal paused(params : PausedParams)
class PausedParams extends ParamsObject:
	var menu_screen : StringName

	func _init(param_menu_screen : StringName):
		super()
		menu_screen = param_menu_screen
func emit_paused(menu_screen : StringName = "Menu"):
	paused.emit(PausedParams.new(menu_screen))

## Emitted when a run is unpaused
signal unpaused()
func emit_unpaused():
	unpaused.emit()

## Emitted when the user elects to quit to the main menu of the game.
signal quit_to_menu()
func emit_quit_to_menu():
	quit_to_menu.emit()

# ENCOUNTER LIFECYCLE

## Emitted when the user left clicks on a cryptograph.
signal cryptograph_discarded(params : CryptographDiscardedParams)
class CryptographDiscardedParams extends ParamsObject:
	var cryptograph_scene : Cryptograph
	var remaining_discards : int
	var letter : String

	func _init(param_cryptograph_scene : Cryptograph, param_remaining_discards: int, param_letter : String):
		super()
		cryptograph_scene = param_cryptograph_scene
		remaining_discards = param_remaining_discards
		letter = param_letter
func emit_cryptograph_discarded(cryptograph_scene : Cryptograph, remaining_discards: int, letter : String):
	cryptograph_discarded.emit(CryptographDiscardedParams.new(cryptograph_scene, remaining_discards, letter))

## Emitted on each letter of the scored word in sequence.
signal letter_scored(params : LetterScoredParams)
class LetterScoredParams extends ParamsObject:
	var letter : StringName

	func _init(param_letter: StringName):
		super()
		letter = param_letter
func emit_letter_scored(letter : StringName):
	letter_scored.emit(LetterScoredParams.new(letter))

## Emitted when a valid word is scored.
signal word_scored(params : WordScoredParams)
class WordScoredParams extends ParamsObject:
	var word : String
	var types : Dictionary[StringName, float]
	var attempts_remaining : int

	func _init(param_word : String, param_types : Dictionary[StringName, float], param_attempts_remaining : int):
		super()
		word = param_word
		types = param_types
		attempts_remaining = param_attempts_remaining
func emit_word_scored(word : String, types : Dictionary[StringName, float], attempts_left : int):
	word_scored.emit(WordScoredParams.new(word, types, attempts_left))

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