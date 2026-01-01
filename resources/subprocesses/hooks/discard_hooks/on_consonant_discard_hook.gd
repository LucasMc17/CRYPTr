class_name OnConsonantDiscardHook
extends DiscardHook
## Discard Hook activated when a consonant is discarded.

func filter(params : Events.ParamsObject) -> bool:
	return Constants.CONSONANTS.contains(params.letter)