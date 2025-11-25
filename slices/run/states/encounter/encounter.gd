extends Switchable

# TODO: These two to be initted via encounter resource during setup function
@export var DEPTH := 1
@export var SECURITY_LEVEL := 1

@onready var HAND := %Hand
@onready var WORD := %Word
@onready var SCORE_PREVIEW := %ScorePreview


var DECK = DeckModule.new()
var DISCARDS : int

@onready var SCORING = ScoringModule.new()
@onready var ATTEMPTS := 4

func _ready():
	Events.cryptograph_right_clicked.connect(_on_cryptograph_right_clicked)
	Events.command_win.connect(func (_params): win())
	Events.command_lose.connect(func (_params): lose())

	DISCARDS = Player.DISCARDS
	if "--debug-encounter" in OS.get_cmdline_args():
		DebugNode.print('ENCOUNTER accessed directly')
		if DebugNode.FORCE_STACK:
			Player.initialize_stack(DebugNode.FORCE_STACK)
			DebugNode.print('Initializing FORCED stack from Debug Node')
		else:
			var CLASSIC_STACK = load("res://resources/starter_decks/the_classic.tres")
			DebugNode.print('Initializing CLASSIC stack')
			Player.initialize_stack(CLASSIC_STACK)
	DECK.init_and_shuffle()
	HAND.add_to_hand(DECK.draw())

	SCORING.CURRENT_SCORE = 0
	SCORING.TARGET_SCORE = (100 + (20 * SECURITY_LEVEL)) * DEPTH


	SCORING.update_score_object(WORD.text, HAND)
	SCORE_PREVIEW.update_potential_score(SCORING.SCORE_OBJECT)

	SCORE_PREVIEW.update_score(SCORING.CURRENT_SCORE, SCORING.TARGET_SCORE)

func _unhandled_input(event):
	# if Input.is_action_just_pressed("escape"):
	# 	DebugNode.print('PAUSED')
	
	if Input.is_action_just_pressed("enter"):
		enter_word()
	
	if Input.is_action_just_pressed("backspace"):
		WORD.backspace()
		SCORING.update_score_object(WORD.text, HAND)
		SCORE_PREVIEW.update_potential_score(SCORING.SCORE_OBJECT)

	if event is InputEventKey and event.pressed == true:
		input_character(event)

func win() -> void:
	DebugNode.print("YOU WON")
	if "--debug-encounter" in OS.get_cmdline_args():
		get_tree().quit(0)
	else:
		Events.match_won.emit()
		Events.return_to_map.emit(false)

func lose() -> void:
	DebugNode.print("YOU LOSE")
	if "--debug-encounter" in OS.get_cmdline_args():
		get_tree().quit(0)
	else:
		Events.run_lost.emit()

func enter_word() -> void:
	if SCORING.SCORE_OBJECT.valid:
		if DebugNode.INSTAWIN:
			win()
			return
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
		if ATTEMPTS < 1 || DECK.all.is_empty():
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

func _on_cryptograph_right_clicked(cryptograph : Cryptograph):
	if DISCARDS > 0:
		HAND.discard(cryptograph)
		WORD.clear()
		SCORING.update_score_object(WORD.text, HAND)
		SCORE_PREVIEW.update_potential_score(SCORING.SCORE_OBJECT)
		if HAND.count == 0 && DECK.all.is_empty():
			lose()
		HAND.add_to_hand(DECK.draw(1))
		DISCARDS -= 1