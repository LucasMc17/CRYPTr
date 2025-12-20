class_name OnConsonantDiscardTrigger
extends Trigger

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(params : Dictionary) -> bool:
	if params.has("letter") and "BCDFGHJKLMNPQRSTVWXYZ".contains(params.letter):
		return true
	return false