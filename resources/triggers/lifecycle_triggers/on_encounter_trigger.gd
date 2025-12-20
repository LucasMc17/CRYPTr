class_name OnEncounterTrigger
extends Trigger

func _init():
	events_signal = "match_started"
	super()


func filter(_params : Dictionary) -> bool:
	return true
