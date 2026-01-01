class_name OnLetterHook
extends LetterHook
## Play Hook activated whenever a specific letter is played and scored.

## The letter this Hook listens for.
@export var letter := "A"

func filter(params : Events.ParamsObject) -> bool:
	return params.letter == letter