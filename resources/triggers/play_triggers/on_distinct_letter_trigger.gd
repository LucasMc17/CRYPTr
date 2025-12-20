class_name OnDistinctLetterTrigger
extends Trigger

var greater : bool
var distinct_target : int

func _init(trigger_greater : bool, trigger_distinct_target : int):
	events_signal = "word_scored"
	greater = trigger_greater
	distinct_target = trigger_distinct_target
	super()


func _get_distinct(word : String) -> int:
	var result = ""
	for letter in word:
		if !result.contains(letter):
			result += letter
	return len(result)


func filter(params : Events.ParamsObject) -> bool:
	var distinct = _get_distinct(params.word)
	if greater:
		return distinct > distinct_target
	else:
		return distinct < distinct_target