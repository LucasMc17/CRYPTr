extends VBoxContainer

@onready var odds_label = %Odds

func update_odds(stack : Array[CryptographRes]) -> void:
	var odds = float(stack.filter(func (cryptograph): return Constants.VOWELS.contains(cryptograph.letter.character) ).size()) / float(stack.size()) * 100 if stack.size() > 0 else 0.0
	odds_label.text = "%0.2f" % odds + "%"