extends VBoxContainer

@onready var letter_odds_holder = %LetterOddsHolder

## Update the labels for all letter odds scenes based on provided array of cryptograph resources.
func update_odds(stack : Array[CryptographRes]) -> void:
	for child in letter_odds_holder.get_children():
		var count = stack.filter(func (cryptograph): return cryptograph.letter.character == child.letter).size()
		var odds = float(count) / float(stack.size()) * 100.0
		child.update_count_and_odds(count, odds)