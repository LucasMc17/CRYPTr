class_name OnVowelDiscardHook
extends DiscardHook
## Discard Hook activated when a vowel is discarded.

func filter(params : Events.ParamsObject) -> bool:
	return Constants.VOWELS.contains(params.letter)