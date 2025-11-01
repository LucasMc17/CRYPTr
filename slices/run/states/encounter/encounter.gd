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

	SCORE_PREVIEW.CURRENT_SCORE = 0
	SCORE_PREVIEW.TARGET_SCORE = (100 + (20 * SECURITY_LEVEL)) * DEPTH

func _unhandled_input(event):
	if Input.is_action_just_pressed("enter"):
		enter_word()
	
	if Input.is_action_just_pressed("backspace"):
		WORD.backspace()
		SCORE_PREVIEW.SCORE_OBJECT = SCORING.create_scoring_object(WORD.text, HAND)

	if event is InputEventKey and event.pressed == true:
		input_character(event)

func win() -> void:
	print("YOU WON")

func lose() -> void:
	print("YOU LOSE")

func enter_word() -> void:
	# SCORING.enter(WORD.text)
	if SCORE_PREVIEW.SCORE_OBJECT.valid:
		SCORE_PREVIEW.CURRENT_SCORE += SCORE_PREVIEW.SCORE_OBJECT.total_score
		HAND.discard_by_letters(WORD.text)
		HAND.add_to_hand(DECK.draw(6 - HAND.count))
		WORD.clear()
		SCORE_PREVIEW.SCORE_OBJECT = SCORING.create_scoring_object("", HAND)
		ATTEMPTS -= 1
		if SCORE_PREVIEW.check_win():
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
			var new_score = SCORING.create_scoring_object(WORD.text, HAND)
			SCORE_PREVIEW.SCORE_OBJECT = new_score