class_name OnWordTrigger
extends Trigger
## Play trigger activated whenever a word is played.

func _init():
	events_signal = "word_scored"
	super()


func filter(_params : Events.ParamsObject) -> bool:
	return true