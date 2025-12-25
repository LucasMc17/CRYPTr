class_name OnLetterTrigger
extends Trigger
## Play trigger activated whenever a specific letter is played and scored.

## The letter this Trigger listens for.
var letter := "A"

func _init(trigger_letter):
	letter = trigger_letter
	trigger_name = "On '" + letter + "' Trigger"
	events_signal = "letter_scored"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return params.letter == letter