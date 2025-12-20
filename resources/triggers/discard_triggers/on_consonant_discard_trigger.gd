class_name OnConsonantDiscardTrigger
extends Trigger

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return "BCDFGHJKLMNPQRSTVWXYZ".contains(params.letter)