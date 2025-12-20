class_name OnFinalWordTrigger
extends Trigger

func _init():
	events_signal = "word_scored"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return params.attempts_remaining == 0