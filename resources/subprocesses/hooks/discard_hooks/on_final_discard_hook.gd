class_name OnFinalDiscardHook
extends Hook
## Discard Hook activated when the player's final discard is used.

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return params.remaining_discards == 0