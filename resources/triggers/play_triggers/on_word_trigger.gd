class_name OnWordTrigger
extends Trigger

func _init():
	events_signal = "word_scored"
	super()


func filter(_params : Dictionary) -> bool:
	return true