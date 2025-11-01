@tool
class_name Cryptograph extends ColorRect

@onready var LETTER_LABEL := %Letter

@onready var POINTS_LABEL := %Points

@export var RESOURCE : CryptographRes:
	set(val):
		if val:
			if LETTER_LABEL:
				LETTER_LABEL.text = val.letter.character
			if POINTS_LABEL:
				POINTS_LABEL.text = str(val.letter.points)
		RESOURCE = val

func _ready():
	if RESOURCE:
		LETTER_LABEL.text = RESOURCE.letter.character
		POINTS_LABEL.text = str(RESOURCE.letter.points)