class_name OnVowelDiscardTrigger
extends Trigger

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(params : Events.ParamsObject) -> bool:
	return "AEIOU".contains(params.letter)