extends HBoxContainer

signal function_shifted(func_index : int, up : bool)

## Whether or not the controls to move functions up and down in priority should be exposed to the player.
var allow_config := false
## The index of this function within its owning hook
var index : int

## The function within the hook which this label represents.
@export var function : Function

@onready var _move_buttons = %MoveButtons
@onready var _function_label = %FunctionLabel
@onready var _up_button = %UpButton
@onready var _down_button = %DownButton

func _ready():
	_function_label.text = '    ' + function.function_name
	if allow_config:
		_move_buttons.visible = true
		if index != 0:
			_up_button.disabled = false
		if index != function.owning_hook.functions.size() - 1:
			_down_button.disabled = false


func _on_up_button_pressed():
	function_shifted.emit(index, true)


func _on_down_button_pressed():
	function_shifted.emit(index, false)