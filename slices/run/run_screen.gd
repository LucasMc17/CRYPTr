extends Switchable

var CLASSIC_STACK = preload("res://resources/starter_decks/the_classic.tres")

func setup(init_obj := {}) -> void:
	super(init_obj)
	Player.initialize_stack(CLASSIC_STACK)