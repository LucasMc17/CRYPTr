class_name Cryptograph extends ColorRect

@onready var LETTER_LABEL := %Letter

@onready var POINTS_LABEL := %Points

# signal clicked(cryptograph_scene : Cryptograph)

# signal right_clicked(cryptograph_scene : Cryptograph)

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

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Events.cryptograph_left_clicked.emit(self)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			Events.cryptograph_right_clicked.emit(self)