class_name OnConsonantHook
extends LetterHook
## Play Hook activated whenever a consonant is played and scored.

func filter(params : Events.ParamsObject) -> bool:
	return Constants.CONSONANTS.contains(params.letter)