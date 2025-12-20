class_name OnConsonantDiscardTrigger
extends Trigger
## Discard trigger activated when a consonant is discarded.

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return Constants.CONSONANTS.contains(params.letter)