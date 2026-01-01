class_name OnDiscardHook
extends DiscardHook
## Discard Hook activated whenever any letter is discarded.

func filter(_params : Events.ParamsObject) -> bool:
	return true