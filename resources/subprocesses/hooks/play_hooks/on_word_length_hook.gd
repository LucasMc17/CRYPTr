class_name OnWordLengthHook
extends Hook
## Play Hook activated whenever a word is played with sufficiently few or many total characters.

## If `true`, the number of letters must be greater than the `length` in order to activate the Hook. Else must be fewer.
@export var greater := true
## The target number, which the count of letters in the word must be larger or smaller than, depending on the value of `greater`.
@export var length := 5

func _init():
	events_signal = "word_scored"
	super()


func filter(params : Events.ParamsObject) -> bool:
	if greater:
		return len(params.word) > length
	else:
		return len(params.word) < length