extends VBoxContainer

var score_section = preload('./score_section.tscn')

@onready var MULT_LIST := %MultList
@onready var SCORE := %Score

@export var CURRENT_SCORE := 0.0:
	set(val):
		update_score(val, TARGET_SCORE)
		CURRENT_SCORE = val
@export var TARGET_SCORE := 0.0:
	set(val):
		update_score(CURRENT_SCORE, val)
		TARGET_SCORE = val

func update_score (current : float, target : float) -> void:
	if SCORE:
		SCORE.text= "Score: " + str(current) + " / " + str(target)

var SCORE_OBJECT : ScoringModule.ScoringObject:
	set(val):
		clear()
		if val and val.valid:
			var word_name = score_section.instantiate()
			word_name.SIZE = "LARGE"
			word_name.NAME = val.word_name
			word_name.MULT = str(val.base_score) + " x " + str(val.length_mult)
			MULT_LIST.add_child(word_name)
			for key in val.additional_mults.keys():
				var multiplier = score_section.instantiate()
				multiplier.SIZE = "MEDIUM"
				multiplier.NAME = key
				multiplier.MULT = "x" + str(val.additional_mults[key])
				MULT_LIST.add_child(multiplier)
			var total_score = score_section.instantiate()
			total_score.SIZE = "LARGE"
			total_score.NAME = "Total"
			total_score.MULT = str(val.total_score)
			MULT_LIST.add_child(total_score)
		SCORE_OBJECT = val

func clear():
	for child in MULT_LIST.get_children():
		child.queue_free()

func check_win() -> bool: 
	return CURRENT_SCORE >= TARGET_SCORE
