class_name OnWordHook
extends Hook
## Play Hook activated whenever a word is played.

func _init():
	events_signal = "word_scored"
	super()


func filter(_params : Events.ParamsObject) -> bool:
	return true