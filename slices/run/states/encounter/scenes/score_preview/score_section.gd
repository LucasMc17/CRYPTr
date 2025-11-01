@tool
extends HBoxContainer

@export_enum("SMALL", "MEDIUM", "LARGE") var SIZE := "SMALL":
	set(val):
		if NAME_LABEL and MULT_LABEL:
			if val == "SMALL":
				NAME_LABEL.set('theme_override_font_sizes/font_size', 25)
				MULT_LABEL.set('theme_override_font_sizes/font_size', 25)
			elif val == "MEDIUM":
				NAME_LABEL.set('theme_override_font_sizes/font_size', 50)
				MULT_LABEL.set('theme_override_font_sizes/font_size', 50)
			elif val == "LARGE":
				NAME_LABEL.set('theme_override_font_sizes/font_size', 75)
				MULT_LABEL.set('theme_override_font_sizes/font_size', 75)
		SIZE = val
@export var NAME := "":
	set(val):
		if NAME_LABEL:
			NAME_LABEL.text = val
		NAME = val
@export var MULT := "":
	set(val):
		if MULT_LABEL:
			MULT_LABEL.text = val
		MULT = val

@onready var NAME_LABEL := %Name
@onready var MULT_LABEL := %Multiplier

func _ready():
	NAME = NAME
	MULT = MULT
	SIZE = SIZE

