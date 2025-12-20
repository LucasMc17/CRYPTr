class_name OnConsonantTrigger
extends Trigger

func _init():
	events_signal = "letter_scored"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return "BCDFGHJKLMNPQRSTVWXYZ".contains(params.letter)