class_name OnFinalWordTrigger
extends Trigger
## Play trigger activated when the player's final word is scored.

func _init():
	events_signal = "word_scored"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return params.attempts_remaining == 0