class_name OnConsonantTrigger
extends Trigger
## Play trigger activated whenever a consonant is played and scored.

func _init():
	events_signal = "letter_scored"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return Constants.CONSONANTS.contains(params.letter)