extends VBoxContainer

var score_section = preload('./score_section.tscn')

@onready var MULT_LIST := %MultList
@onready var SCORE := %Score

func update_score(current : float, target : float) -> void:
	if SCORE:
		SCORE.text= "Score: " + str(current) + " / " + str(target)

func update_potential_score(score_object : ScoringModule.ScoringObject) -> void:
	clear()
	if score_object.valid:
		var word_name = score_section.instantiate()
		word_name.SIZE = "LARGE"
		word_name.NAME = score_object.word_name
		word_name.MULT = str(score_object.base_score) + " x " + str(score_object.length_mult)
		MULT_LIST.add_child(word_name)
		for key in score_object.additional_mults.keys():
			var multiplier = score_section.instantiate()
			multiplier.SIZE = "MEDIUM"
			multiplier.NAME = key
			multiplier.MULT = "x" + str(score_object.additional_mults[key])
			MULT_LIST.add_child(multiplier)
		var total_score = score_section.instantiate()
		total_score.SIZE = "LARGE"
		total_score.NAME = "Total"
		total_score.MULT = str(score_object.total_score)
		MULT_LIST.add_child(total_score)

func clear():
	for child in MULT_LIST.get_children():
		child.queue_free()
