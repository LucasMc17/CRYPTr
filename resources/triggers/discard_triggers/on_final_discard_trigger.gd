class_name OnFinalDiscardTrigger
extends Trigger

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return params.remaining_discards == 0