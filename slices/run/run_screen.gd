extends UIState

var CLASSIC_STACK = preload("res://resources/starter_decks/the_classic.tres")

@onready var PLAYER = %PlayerModule

func enter(previous_state, ext):
	super(previous_state, ext)
	PLAYER.initialize_stack(CLASSIC_STACK)
	print(PLAYER.STACK)
