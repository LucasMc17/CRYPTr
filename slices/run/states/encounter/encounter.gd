extends Switchable

@export var DEPTH := 1
@export var SECURITY_LEVEL := 1

@onready var TARGET_SCORE_LABEL = %TargetScoreLabel
@onready var MATCH = %MatchStateModule

func setup(setup_obj := {}) -> void:
	super(setup_obj)

func _ready():
	MATCH.initialize_encounter(DEPTH, SECURITY_LEVEL)
