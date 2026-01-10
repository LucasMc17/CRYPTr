class_name OnVowelHook
extends LetterHook
## Play Hook activated whenever a vowel is played and scored.

func filter(params : Events.ParamsObject) -> bool:
	return Constants.VOWELS.contains(params.letter)