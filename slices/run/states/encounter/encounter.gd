extends Switchable
## Encounter instance within a run. Handles all logic related to drawing cards to hand, discarding, inputting characters and entering words.
##
## All variables and functions are private, this scene is not meant to be interacted with from a higher level, but handle all of its inputs
## itself. Instantiates a `DeckModule` and a `ScoringModule` to handle the finer points of deck management and scoring.

# TODO: These two to be initted via encounter resource during setup function
@export var _depth := 1
@export var _security_level := 1

## The `DeckModule` representing the player's full, shuffled deck. Responsible for all logic regarding drawing from deck and shuffling.
# var _deck = DeckModule.new(true)
var _deck : DeckModule
## The `ScoringModule` responsible for validating and scoring potential words, as well as managing the player's current score.
var _scoring = ScoringModule.new()
## The player's remaining discards, instantiated in the `_ready` function.
var _discards : int
## The player's remaining attempts, instantiated in the `_ready` function
var _attempts := 4

## The player's current hand of cryptographs. Not a logic module like the deck or scorer, since the hand has a visual component in the encounter.
@onready var _hand := %Hand
## The player's current word entry. Not a logic module like the deck or scorer, since the word has a visual component in the encounter.
@onready var _word := %Word
## The score preview, utilizing the current ScoringObject to show a base score, multipliers, and total score for the typed word before entering.
@onready var _score_preview := %ScorePreview

func _ready():
	Events.cryptograph_right_clicked.connect(_on_cryptograph_right_clicked)
	Events.command_win.connect(func (_params): _win())
	Events.command_lose.connect(func (_params): _lose())

	_discards = Player.discards
	if "--debug-encounter" in OS.get_cmdline_args():
		DebugNode.print('ENCOUNTER accessed directly')
		if DebugNode.force_stack:
			Player.initialize_stack(DebugNode.force_stack)
			DebugNode.print('Initializing FORCED stack from Debug Node')
		else:
			var CLASSIC_STACK = load("res://resources/starter_decks/the_classic.tres")
			DebugNode.print('Initializing CLASSIC stack')
			Player.initialize_stack(CLASSIC_STACK)
	_deck = DeckModule.new(true)
	_hand.add_to_hand(_deck.draw())

	_scoring.current_score = 0
	_scoring.target_score = (100 + (20 * _security_level)) * _depth

	_scoring.update_score_object(_word.text, _hand)
	_score_preview.update_potential_score(_scoring.score_object)

	_score_preview.update_score(_scoring.current_score, _scoring.target_score)


func _unhandled_input(event):
	# TODO: the code below was for testing purposes but should be moved to a higher level so that pausing can happen from any screen in the run.
	# if Input.is_action_just_pressed("escape"):
	# 	DebugNode.print('PAUSED')
	
	if Input.is_action_just_pressed("enter"):
		_enter_word()
	
	if Input.is_action_just_pressed("backspace"):
		_word.backspace()
		_scoring.update_score_object(_word.text, _hand)
		_score_preview.update_potential_score(_scoring.score_object)

	if event is InputEventKey and event.pressed == true:
		_input_character(event)


## Signals that the encounter was won to trigger the run UISwitcher back to the map.
func _win() -> void:
	DebugNode.print("YOU WON")
	if "--debug-encounter" in OS.get_cmdline_args():
		get_tree().quit(0)
	else:
		Events.match_won.emit()
		Events.return_to_map.emit(false)


## Signals that the encounter was lost, and ends the run.
func _lose() -> void:
	DebugNode.print("YOU LOSE")
	if "--debug-encounter" in OS.get_cmdline_args():
		get_tree().quit(0)
	else:
		Events.run_lost.emit()


## Enters the currently inputted word, assuming it is valid.
func _enter_word() -> void:
	if _scoring.score_object.valid:
		if DebugNode.instawin:
			_win()
			return
		
		_scoring.current_score += _scoring.score_object.total_score
		_score_preview.update_score(_scoring.current_score, _scoring.target_score)

		_hand.discard_by_letters(_word.text)
		_hand.add_to_hand(_deck.draw(Player.HAND_SIZE - _hand.count))

		_word.clear()

		_scoring.update_score_object(_word.text, _hand)
		_score_preview.update_potential_score(_scoring.score_object)

		_attempts -= 1

		if _scoring.check_win():
			_win()
			return
		if _attempts < 1 || _deck.all.is_empty():
			_lose()
			return


## Adds a character to the words when the corresponding key is pressed, assuming the `_hand` contains that character.
func _input_character(event) -> void:
	var keycode = event.keycode
	if keycode >= KEY_A && keycode <= KEY_Z:
		var character = OS.get_keycode_string(event.key_label)
		if DebugNode.accept_all_letters or _hand.letters.has(character):
			_word.add_character(character)
			_scoring.update_score_object(_word.text, _hand)
			_score_preview.update_potential_score(_scoring.score_object)


## Discards a cryptograph when it is right clicked.
func _on_cryptograph_right_clicked(cryptograph : Cryptograph) -> void:
	if _discards > 0:
		_hand.discard(cryptograph)
		_word.clear()
		_scoring.update_score_object(_word.text, _hand)
		_score_preview.update_potential_score(_scoring.score_object)
		if _hand.count == 0 && _deck.all.is_empty():
			_lose()
		_hand.add_to_hand(_deck.draw(1))
		_discards -= 1