class_name OnWordLengthTrigger
extends Trigger

var greater : bool
var length : int

func _init(trigger_greater : bool, trigger_length : int):
	events_signal = "word_scored"
	greater = trigger_greater
	length = trigger_length
	super()


func filter(params : Events.ParamsObject) -> bool:
	if greater:
		return len(params.word) > length
	else:
		return len(params.word) < length