class_name OnVowelTrigger
extends Trigger
## Play trigger activated whenever a vowel is played and scored.

func _init():
	events_signal = "letter_scored"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return Constants.VOWELS.contains(params.letter)