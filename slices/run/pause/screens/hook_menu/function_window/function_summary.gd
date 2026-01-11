extends PanelContainer

## The Function this summary represents.
var function : Function
## The currently examined hook for pairing with this Function.
var current_hook : Hook
## Whether the Function is currently in use by another Hook.
var in_use : bool:
	get():
		return function.owning_hook != null
## Whether the Function is currently installed on the current Hook.
var already_installed : bool:
	get():
		return function.owning_hook == current_hook
## Whether the current hook has enough memory to install the Function.
var affordable : bool:
	get():
		return function.cost <= current_hook.memory_available
## Whether or not the function is ultimately installable based on the factors above.
var usable : bool:
	get():
		return !in_use && !already_installed && affordable

@onready var _function_name := %Name
@onready var _function_cost := %Cost
# @onready var _function_description := %Description
@onready var _in_use_label := %InUseLabel
@onready var _installed_label := %InstalledLabel
@onready var _insufficient_memory_label := %InsufficientMemoryLabel

func _ready():
	if function:
		_function_cost.text = str(function.cost)
		_function_name.text = function.function_name
		# _function_description.text = function.description


## Updates the color of the Function summary based on its availability
func update_color():
	_in_use_label.visible = false
	_installed_label.visible = false
	_insufficient_memory_label.visible = false
	if already_installed:
		_installed_label.visible = true
		# self_modulate = '#5affff'
		theme_type_variation = "Installed"
	elif in_use:
		_in_use_label.visible = true
		theme_type_variation = "InUse"
		# self_modulate = '#999999'
	elif !affordable:
		_insufficient_memory_label.visible = true
		theme_type_variation = "InsufficientMemory"
		# self_modulate = '#FF0000'
	else:
		theme_type_variation = "Available"
		# self_modulate = "#FFFFFF"


## Updates the currently accessed Hook, and updates the colors of the Functions based on their availability.
func populate(h : Hook):
	current_hook = h

	update_color()


func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if already_installed:
			current_hook.remove_function(function)
			Events.refresh_hooks.emit()
		elif usable:
			current_hook.add_function(function)
			Events.refresh_hooks.emit()