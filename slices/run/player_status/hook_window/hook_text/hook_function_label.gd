extends HBoxContainer

## Whether or not the controls to move functions up and down in priority should be exposed to the player.
var allow_config := false

## The function within the hook which this label represents.
@export var function : Function

@onready var move_buttons = %MoveButtons

func _ready():
	if allow_config:
		move_buttons.visible = true