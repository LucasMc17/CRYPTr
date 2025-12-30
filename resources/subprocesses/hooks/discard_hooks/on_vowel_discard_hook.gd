class_name OnVowelDiscardHook
extends Hook
## Discard Hook activated when a vowel is discarded.

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return Constants.VOWELS.contains(params.letter)