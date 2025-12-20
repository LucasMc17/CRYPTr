class_name OnLetterTrigger
extends Trigger

## The letter this Trigger listens for.
var letter := "A"

func _init(trigger_letter):
	letter = trigger_letter
	events_signal = "letter_scored"
	super()


func filter(params : Dictionary) -> bool:
	if params.has("letter") and params.letter == letter:
		return true
	return false