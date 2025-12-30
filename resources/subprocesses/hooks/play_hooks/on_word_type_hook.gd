class_name OnWordTypeHook
extends Hook
## Play Hook activated whenever a word is played of the Hook's specified type.

## The type of word which activates this Hook when played.
@export var word_type := "isogram"

func _init():
	events_signal = "word_scored"
	super()

func filter(params : Events.ParamsObject) -> bool:
	return params.types.has(word_type)