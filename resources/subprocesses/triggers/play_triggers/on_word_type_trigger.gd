class_name OnWordTypeTrigger
extends Trigger
## Play trigger activated whenever a word is played of the trigger's specified type.

## The type of word which activates this trigger when played.
var word_type : String

func _init(trigger_word_type : String):
	word_type = trigger_word_type
	events_signal = "word_scored"
	super()

func filter(params : Events.ParamsObject) -> bool:
	return params.types.has(word_type)