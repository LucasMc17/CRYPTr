extends HBoxContainer

## Whether or not the controls to move functions up and down in priority should be exposed to the player.
var allow_config := false

## The function within the hook which this label represents.
@export var function : Function

@onready var _move_buttons = %MoveButtons
@onready var _function_label = %FunctionLabel

func _ready():
	_function_label.text = '    ' + function.function_name
	if allow_config:
		_move_buttons.visible = true