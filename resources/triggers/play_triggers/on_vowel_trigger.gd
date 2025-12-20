class_name OnVowelTrigger
extends Trigger

func _init():
	events_signal = "letter_scored"
	super()


func filter(params : Dictionary) -> bool:
	if params.has("letter") and "AEIOU".contains(params.letter):
		return true
	return false