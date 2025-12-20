class_name OnFinalDiscardTrigger
extends Trigger
## Discard trigger activated when the player's final discard is used.

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return params.remaining_discards == 0