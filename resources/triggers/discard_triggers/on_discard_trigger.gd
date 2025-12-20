class_name OnDiscardTrigger
extends Trigger

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(_params : Dictionary) -> bool:
	return true