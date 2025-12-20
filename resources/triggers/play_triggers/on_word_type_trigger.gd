class_name OnWordTypeTrigger
extends Trigger

var word_type : String

func _init(trigger_word_type : String):
	word_type = trigger_word_type
	events_signal = "word_scored"
	super()

func filter(params : Dictionary) -> bool:
	if params.has("types") and params.types.has(word_type):
		return true
	return false