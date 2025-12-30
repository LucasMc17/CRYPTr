class_name OnLetterHook
extends Hook
## Play Hook activated whenever a specific letter is played and scored.

## The letter this Hook listens for.
@export var letter := "A"

func _init():
	hook_name = "On '" + letter + "' Hook"
	events_signal = "letter_scored"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return params.letter == letter