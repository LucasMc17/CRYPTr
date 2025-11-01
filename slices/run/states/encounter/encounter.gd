extends Switchable

@export var DEPTH := 1
@export var SECURITY_LEVEL := 1

# @export var SCORE := 0.0
# @export var TARGET_SCORE := 0

@onready var HAND := %Hand
@onready var WORD := %Word
@onready var SCORE_PREVIEW := %ScorePreview


var DECK = DeckModule.new()
@onready var SCORING = ScoringModule.new()
@onready var ATTEMPTS := 4

func _ready():
	if "--initialize-deck" in OS.get_cmdline_args():
		print('ENCOUNTER accessed directly, initializing CLASSIC stack')
		var CLASSIC_STACK = load("res://resources/starter_decks/the_classic.tres")
		Player.initialize_stack(CLASSIC_STACK)
	DECK.init_and_shuffle()
	HAND.add_to_hand(DECK.draw())

	SCORING.CURRENT_SCORE = 0
	SCORING.TARGET_SCORE = (100 + (20 * SECURITY_LEVEL)) * DEPTH

	SCORE_PREVIEW.update_score(SCORING.CURRENT_SCORE, SCORING.TARGET_SCORE)

func _unhandled_input(event):
	if Input.is_action_just_pressed("enter"):
		enter_word()
	
	if Input.is_action_just_pressed("backspace"):
		WORD.backspace()
		SCORING.update_score_object(WORD.text, HAND)
		SCORE_PREVIEW.update_potential_score(SCORING.SCORE_OBJECT)

	if event is InputEventKey and event.pressed == true:
		input_character(event)

func win() -> void:
	print("YOU WON")

func lose() -> void:
	print("YOU LOSE")

func enter_word() -> void:
	if SCORING.SCORE_OBJECT.valid:
		SCORING.CURRENT_SCORE += SCORING.SCORE_OBJECT.total_score
		SCORE_PREVIEW.update_score(SCORING.CURRENT_SCORE, SCORING.TARGET_SCORE)
		HAND.discard_by_letters(WORD.text)
		HAND.add_to_hand(DECK.draw(6 - HAND.count))
		WORD.clear()
		SCORING.update_score_object(WORD.text, HAND)
		SCORE_PREVIEW.update_potential_score(SCORING.SCORE_OBJECT)
		ATTEMPTS -= 1
		if SCORING.check_win():
			win()
			return
		if ATTEMPTS < 1:
			lose()
			return

func input_character(event) -> void:
	var keycode = event.keycode
	if keycode >= KEY_A && keycode <= KEY_Z:
		var character = OS.get_keycode_string(event.key_label)
		if DebugNode.ACCEPT_ALL_LETTERS or HAND.letters.has(character):
			WORD.add_character(character)
			SCORING.update_score_object(WORD.text, HAND)
			SCORE_PREVIEW.update_potential_score(SCORING.SCORE_OBJECT)