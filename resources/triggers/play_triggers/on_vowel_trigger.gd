class_name OnVowelTrigger
extends Trigger

func _init():
	events_signal = "letter_scored"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return "AEIOU".contains(params.letter)