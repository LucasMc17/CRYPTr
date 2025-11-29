class_name ScorePreview
extends VBoxContainer
## The score preview for the encounter.

## Preloaded score section scene for populating as needed.
var _score_section = preload('./score_section.tscn')

@onready var _mult_list := %MultList
@onready var _score := %Score

## Updates the overall score label with the latest information.
func update_score(current : float, target : float) -> void:
	if _score:
		_score.text= "Score: " + str(current) + " / " + str(target)


## Updates the score with new score sections representing all applicable multipliers.
func update_potential_score(score_object : ScoringModule.ScoringObject) -> void:
	clear()
	if score_object.valid:
		var word_name = _score_section.instantiate()
		word_name.section_size = ScoreSection.Sizes.LARGE
		word_name.name_text = score_object.word_name
		word_name.mult_text = str(score_object.base_score) + " x " + str(score_object.length_mult)
		_mult_list.add_child(word_name)
		for key in score_object.additional_mults.keys():
			var multiplier = _score_section.instantiate()
			multiplier.section_size = ScoreSection.Sizes.MEDIUM
			multiplier.name_text = key
			multiplier.mult_text = "x" + str(score_object.additional_mults[key])
			_mult_list.add_child(multiplier)
		var total_score = _score_section.instantiate()
		total_score.section_size = ScoreSection.Sizes.LARGE
		total_score.name_text = "Total"
		total_score.mult_text = str(score_object.total_score)
		_mult_list.add_child(total_score)


## Clears the score preview of all content.
func clear() -> void:
	for child in _mult_list.get_children():
		child.queue_free()
