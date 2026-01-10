class_name OnFinalDiscardHook
extends DiscardHook
## Discard Hook activated when the player's final discard is used.

func filter(params : Events.ParamsObject) -> bool:
	return params.remaining_discards == 0