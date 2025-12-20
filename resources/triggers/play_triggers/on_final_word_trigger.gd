class_name OnFinalWordTrigger
extends Trigger

func _init():
	events_signal = "word_scored"
	super()


func filter(params : Dictionary) -> bool:
	if params.has("attempts_remaining"):
		return params.attempts_remaining == 0
	return false