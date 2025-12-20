class_name OnDiscardLetterTrigger
extends Trigger

var letter : String

func _init(trigger_letter):
	letter = trigger_letter
	events_signal = "cryptograph_discarded"
	super()

	
func filter(params : Events.ParamsObject) -> bool:
	return params.letter == letter