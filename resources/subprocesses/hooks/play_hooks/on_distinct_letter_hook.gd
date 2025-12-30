class_name OnDistinctLetterHook
extends Hook
## Play Hook activated whenever a word is played with sufficiently few or many distinct letters.

## If `true`, the number of distinct letters must be greater than the `distinct_target` in order to activate the Hook. Else must be fewer.
var greater : bool
## The target number, which the count of distinct letters in the word must be larger or smaller than, depending on the value of `greater`.
var distinct_target : int

func _init(hook_greater : bool, hook_distinct_target : int):
	events_signal = "word_scored"
	greater = hook_greater
	distinct_target = hook_distinct_target
	super()


## Utility function which returns the number of distinct letters in the played word.
func _get_distinct(word : String) -> int:
	var result = ""
	for letter in word:
		if !result.contains(letter):
			result += letter
	return len(result)


func filter(params : Events.ParamsObject) -> bool:
	var distinct = _get_distinct(params.word)
	if greater:
		return distinct > distinct_target
	else:
		return distinct < distinct_target