class_name OnFinalDiscardTrigger
extends Trigger

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(params : Dictionary) -> bool:
	if params.has("remaining_discards"):
		return params.remaining_discards == 0
	return false