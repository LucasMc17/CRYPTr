@tool
extends HBoxContainer
## UI module for displaying a letter, it's count, and the odds of drawing it next from the deck. For use in the stack section of the pause menu.

## The character this label represents.
@export var letter := "A"
## Whether or not the given letter is a vowel.
@export var _is_vowel := false

@onready var _letter_label := %Letter
@onready var _count_label := %Count
@onready var _odds_label := %Odds

## Update the labels text with the count of the given letter and odds to draw one next.
func update_count_and_odds(count : int, odds: float):
	_count_label.text = str(count)
	_odds_label.text = "%0.1f" % odds + "%"


func _ready():
	_letter_label.text = letter
	if _is_vowel:
		modulate = "#FF0000"