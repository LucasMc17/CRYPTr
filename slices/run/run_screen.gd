extends UIState

var CLASSIC_STACK = preload("res://resources/starter_decks/the_classic.tres")

@onready var RUN_STATE_MACHINE = %RunStateMachine

func _ready():
	Events.new_run_started.connect(func (): RUN_STATE_MACHINE.transition("Encounter"))

func enter(previous_state, ext):
	super(previous_state, ext)
	Player.initialize_stack(CLASSIC_STACK)
	# print(Player.STACK)
