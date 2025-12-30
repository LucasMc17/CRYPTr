class_name OnDiscardLetterHook
extends Hook
## Discard Hook activated when a specified letter is discarded.

## The letter that activates this Hook when discarded.
@export var letter := "A"

func _init():
	events_signal = "cryptograph_discarded"
	super()

	
func filter(params : Events.ParamsObject) -> bool:
	return params.letter == letter