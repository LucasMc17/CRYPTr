extends Switchable
## Encounter instance within a run. Handles all logic related to drawing cards to hand, discarding, inputting characters and entering words.
##
## All variables and functions are private, this scene is not meant to be interacted with from a higher level, but handle all of its inputs
## itself. Instantiates a `DeckModule` and a `ScoringModule` to handle the finer points of deck management and scoring.

## The encounter resource which this encounter instance. Typically instantiated within the `setup` function.
var encounter : EncounterRes
## The `DeckModule` representing the player's full, shuffled deck. Responsible for all logic regarding drawing from deck and shuffling.
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
	var on_e_trigger = OnLetterTrigger.new("E")

	# Events.cryptograph_right_clicked.connect(_on_cryptograph_right_clicked)
	Events.command_win.connect(func (_params): _win())
	Events.command_lose.connect(func (_params): _lose())

	_discards = Player.discards
	if "--debug-encounter" in OS.get_cmdline_args():
		DebugNode.print('ENCOUNTER accessed directly')
		var debug_encounter = EncounterRes.new("MATCH", 0, null, 0, 0, 0)
		encounter = debug_encounter
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
	_scoring.target_score = (50 + (20 * (encounter.security_level + 1))) * (encounter.session_depth + 1)

	_scoring.update_score_object(_word.text, _hand)
	_score_preview.update_potential_score(_scoring.score_object)

	_score_preview.update_score(_scoring.current_score, _scoring.target_score)


func _unhandled_input(event):
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
	Player.current_stack = Player.stack
	if "--debug-encounter" in OS.get_cmdline_args():
		get_tree().quit(0)
	else:
		Events.match_won.emit()
		Events.return_to_map.emit({"new_map": false})


## Signals that the encounter was lost, and ends the run.
func _lose() -> void:
	DebugNode.print("YOU LOSE")
	Player.current_stack = Player.stack
	if "--debug-encounter" in OS.get_cmdline_args():
		get_tree().quit(0)
	else:
		Events.run_lost.emit()


# TODO: A lot of this is going to change so we can iterate through a scored word with animations and sound effects. The score preview too.
## Enters the currently inputted word, assuming it is valid.
func _enter_word() -> void:
	if _scoring.score_object.valid:
		Player.add_anagram(_word.text)
		for letter in _word.text:
			DebugNode.print(letter)
			Events.letter_scored.emit({ "letter": letter })
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


func _on_hand_discarded(cryptograph : Cryptograph):
	if _discards > 0:
		Events.cryptograph_discarded.emit({ "cryptograph_scene": cryptograph })
		_hand.discard(cryptograph)
		_word.clear()
		_scoring.update_score_object(_word.text, _hand)
		_score_preview.update_potential_score(_scoring.score_object)
		if _hand.count == 0 && _deck.all.is_empty():
			_lose()
		_hand.add_to_hand(_deck.draw(1))
		_discards -= 1