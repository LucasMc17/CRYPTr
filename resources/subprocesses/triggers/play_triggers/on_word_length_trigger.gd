class_name OnWordLengthTrigger
extends Trigger
## Play trigger activated whenever a word is played with sufficiently few or many total characters.

## If `true`, the number of letters must be greater than the `length` in order to activate the trigger. Else must be fewer.
var greater : bool
## The target number, which the count of letters in the word must be larger or smaller than, depending on the value of `greater`.
var length : int

func _init(trigger_greater : bool, trigger_length : int):
	events_signal = "word_scored"
	greater = trigger_greater
	length = trigger_length
	super()


func filter(params : Events.ParamsObject) -> bool:
	if greater:
		return len(params.word) > length
	else:
		return len(params.word) < length