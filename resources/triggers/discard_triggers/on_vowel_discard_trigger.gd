class_name OnVowelDiscardTrigger
extends Trigger

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(params : Dictionary) -> bool:
	if params.has("letter") and "AEIOU".contains(params.letter):
		return true
	return false