class_name ScoreSection
extends HBoxContainer
## An individual section (line) of the score preview.

## Size options for the section font.
enum Sizes {SMALL, MEDIUM, LARGE}

## Controls the section_size of the text in this score section.
var section_size := Sizes.SMALL
## Text of the name (left side) of the score section.
var name_text := ""
## Text of the mult (right side) of the score section.
var mult_text := ""

@onready var name_label := %Name
@onready var mult_label := %Multiplier

func _ready():
	name_label.text = name_text
	mult_label.text = mult_text
	if section_size == Sizes.SMALL:
		name_label.set('theme_override_font_sizes/font_size', 25)
		mult_label.set('theme_override_font_sizes/font_size', 25)
	elif section_size == Sizes.MEDIUM:
		name_label.set('theme_override_font_sizes/font_size', 50)
		mult_label.set('theme_override_font_sizes/font_size', 50)
	elif section_size == Sizes.LARGE:
		name_label.set('theme_override_font_sizes/font_size', 75)
		mult_label.set('theme_override_font_sizes/font_size', 75)
