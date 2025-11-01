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

func _ready():
	DECK.init_and_shuffle()
	HAND.add_to_hand(DECK.draw())

	SCORE_PREVIEW.CURRENT_SCORE = 0
	SCORE_PREVIEW.TARGET_SCORE = (100 + (20 * SECURITY_LEVEL)) * DEPTH

func _unhandled_input(event):
	if Input.is_action_just_pressed("enter"):
		# SCORING.enter(WORD.text)
		print(SCORE_PREVIEW.SCORE_OBJECT)
		if SCORE_PREVIEW.SCORE_OBJECT.valid:
			SCORE_PREVIEW.CURRENT_SCORE += SCORE_PREVIEW.SCORE_OBJECT.total_score
			var to_draw = HAND.discard_by_letters(WORD.text)
			HAND.add_to_hand(DECK.draw(to_draw))
			WORD.clear()
	
	if Input.is_action_just_pressed("backspace"):
		WORD.backspace()
		SCORE_PREVIEW.SCORE_OBJECT = SCORING.create_scoring_object(WORD.text, HAND)

	if event is InputEventKey and event.pressed == true:
		var keycode = event.keycode
		if keycode >= KEY_A && keycode <= KEY_Z:
			var character = OS.get_keycode_string(event.key_label)
			if DebugNode.ACCEPT_ALL_LETTERS or HAND.letters.has(character):
				WORD.add_character(character)
				var new_score = SCORING.create_scoring_object(WORD.text, HAND)
				print(WORD.text, new_score.to_object())
				SCORE_PREVIEW.SCORE_OBJECT = new_score