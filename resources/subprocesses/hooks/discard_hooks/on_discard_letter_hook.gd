class_name OnDiscardLetterHook
extends DiscardHook
## Discard Hook activated when a specified letter is discarded.

## The letter that activates this Hook when discarded.
@export var letter := "A"
	
func filter(params : Events.ParamsObject) -> bool:
	return params.letter == letter