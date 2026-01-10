class_name OnWordHook
extends WordHook
## Play Hook activated whenever a word is played.

func filter(_params : Events.ParamsObject) -> bool:
	return true