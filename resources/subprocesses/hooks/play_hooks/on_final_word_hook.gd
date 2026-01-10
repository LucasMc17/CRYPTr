class_name OnFinalWordHook
extends WordHook
## Play Hook activated when the player's final word is scored.

func filter(params : Events.ParamsObject) -> bool:
	return params.attempts_remaining == 0