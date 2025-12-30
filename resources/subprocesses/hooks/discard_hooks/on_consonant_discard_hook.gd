class_name OnConsonantDiscardHook
extends Hook
## Discard Hook activated when a consonant is discarded.

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return Constants.CONSONANTS.contains(params.letter)