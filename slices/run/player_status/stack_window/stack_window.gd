extends PanelContainer

@onready var _stack_amounts = %StackAmounts

## Sets the label with the current stack amounts as strings.
func set_amounts(current : int, total : int) -> void:
	_stack_amounts.text = str(current) + " / " + str(total)


## Resets the label amounts to the current total stack size.
func reset() -> void:
	set_amounts(Player.current_stack.size(), Player.stack.size())


func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Events.emit_paused("Stack")


func _ready():
	Events.refresh_stack.connect(_on_stack_updated)
	reset()


func _on_stack_updated():
	reset()