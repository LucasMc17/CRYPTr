class_name OnDiscardLetterTrigger
extends Trigger

var letter : String

func _init(trigger_letter):
	letter = trigger_letter
	events_signal = "cryptograph_discarded"
	super()

	
func filter(params : Dictionary) -> bool:
	if params.has("letter") and params.letter == letter:
		return true
	return false