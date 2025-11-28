class_name Cryptograph
extends ColorRect
## Scene representing a cryptograph in the player's stack.

# signal clicked(cryptograph_scene : Cryptograph)
# signal right_clicked(cryptograph_scene : Cryptograph)

## The resource representing the cryptograph's information.
@export var resource : CryptographRes:
	set(val):
		if val:
			if letter_label:
				letter_label.text = val.letter.character
			if points_label:
				points_label.text = str(val.letter.points)
		resource = val

## The label comprising the cryptograph's letter for use in potential words.
@onready var letter_label := %Letter
## The label comprising the cryptograph's point value for scoring valid words.
@onready var points_label := %Points

func _ready():
	if resource:
		letter_label.text = resource.letter.character
		points_label.text = str(resource.letter.points)


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Events.cryptograph_left_clicked.emit(self)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			Events.cryptograph_right_clicked.emit(self)
