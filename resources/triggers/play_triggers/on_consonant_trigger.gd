class_name OnConsonantTrigger
extends Trigger

func _init():
	events_signal = "letter_scored"
	super()


func filter(params : Dictionary) -> bool:
	if params.has("letter") and "BCDFGHJKLMNPQRSTVWXYZ".contains(params.letter):
		return true
	return false