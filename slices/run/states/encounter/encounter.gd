extends UIState

@export var DEPTH := 1
@export var SECURITY_LEVEL := 1

@onready var TARGET_SCORE_LABEL = %TargetScoreLabel
@onready var MATCH = %MatchStateModule

func enter(previous_state, ext):
	super(previous_state, ext)
	print('entering encounter')
	MATCH.initialize_encounter(DEPTH, SECURITY_LEVEL)
	print(MATCH.ENCOUNTER_STACK)
