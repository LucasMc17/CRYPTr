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
## Boolean controlling whether the player can interact with the encounter currently.
var is_input_ready := true

## The player's current hand of cryptographs. Not a logic module like the deck or scorer, since the hand has a visual component in the encounter.
@onready var _hand := %Hand
## The player's current word entry. Not a logic module like the deck or scorer, since the word has a visual component in the encounter.
@onready var _word := %Word
## The score preview, utilizing the current ScoringObject to show a base score, multipliers, and total score for the typed word before entering.
@onready var _score_preview := %ScorePreview

func _ready():
	Events.command_win.connect(func (_params): _win())
	Events.command_lose.connect(func (_params): _lose())

	if DebugNode.command_args.is_debug_encounter:
		DebugNode.print_n('ENCOUNTER accessed directly')

	_discards = Player.discards
	_deck = DeckModule.new(true)
	_hand.add_to_hand(_deck.draw())

	_scoring.current_score = 0
	_scoring.target_score = (50 + (20 * (encounter.security_level + 1))) * (encounter.session_depth + 1)

	_scoring.update_score_object(_word.text, _hand)
	_score_preview.update_potential_score(_scoring.score_object)

	_score_preview.update_score(_scoring.current_score, _scoring.target_score)


func _unhandled_input(event):
	if is_input_ready:
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
	Player.current_stack = Player.stack
	Events.refresh_stack.emit()
	Events.emit_match_won()
	if DebugNode.command_args.is_debug_encounter:
		get_tree().quit(0)
	else:
		Events.emit_return_to_map(false)


## Signals that the encounter was lost, and ends the run.
func _lose() -> void:
	Player.current_stack = Player.stack
	Events.refresh_stack.emit()
	if DebugNode.command_args.is_debug_encounter:
		get_tree().quit(0)
	else:
		is_input_ready = false
		Events.emit_run_lost()


## Enters the currently inputted word, assuming it is valid.
func _enter_word() -> void:
	if _scoring.score_object.valid:
		_attempts -= 1
		_scoring.score_word(_hand.cryptographs, _attempts)
		# Events.emit_word_scored(_word.text, _scoring.score_object.additional_mults, _attempts)
		_score_preview.update_score(_scoring.current_score, _scoring.target_score)

		if _scoring.check_win() || DebugNode.instawin:
			_win()
			return
		if _attempts < 1 || _deck.all.is_empty():
			_lose()
			return
		
		_hand.discard_by_letters(_word.text)
		_hand.add_to_hand(_deck.draw(Player.HAND_SIZE - _hand.count))

		_word.clear()

		_scoring.update_score_object(_word.text, _hand)
		_score_preview.update_potential_score(_scoring.score_object)



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
		Events.emit_cryptograph_discarded(cryptograph, _discards - 1, cryptograph.resource.letter.character)
		_hand.discard(cryptograph)
		_word.clear()
		_scoring.update_score_object(_word.text, _hand)
		_score_preview.update_potential_score(_scoring.score_object)
		if _hand.count == 0 && _deck.all.is_empty():
			_lose()
		_hand.add_to_hand(_deck.draw(1))
		_discards -= 1