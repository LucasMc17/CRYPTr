class_name OnVowelDiscardTrigger
extends Trigger
## Discard trigger activated when a vowel is discarded.

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return "AEIOU".contains(params.letter)