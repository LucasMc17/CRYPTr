class_name DebugConsole extends PanelContainer

# NODES
@onready var History = %History
@onready var CommandLine = %CommandLine

# GLOBALS
var command_history := []
var _history_pointer

# FUNCS
func get_from_history(pointer : int):
	_history_pointer = pointer
	CommandLine.text = command_history[pointer]
	CommandLine.set_caret_column(1000)

func clear():
	History.text = ''

# BUILT INS
# func _ready():
# 	Global.Debug.DEBUG_CONSOLE = self
# 	if Global.Debug.debug_override == "DEFER":
# 		visible = Global.Debug.show_debug_console

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		CommandLine.grab_focus()

func _input(_event):
	if CommandLine.has_focus() and Input.is_action_just_pressed("up"):
		if _history_pointer == 0:
			return
		if _history_pointer != null and _history_pointer > 0:
			get_from_history(_history_pointer - 1)
			return
		elif !_history_pointer and command_history.size() > 0:
			get_from_history(command_history.size() - 1)
			return
	elif CommandLine.has_focus() and Input.is_action_just_pressed("down"):
		if _history_pointer != null and _history_pointer < command_history.size() - 1:
			get_from_history(_history_pointer + 1)
			return

# SIGNAL LISTENERS
# func _on_command_line_text_submitted(new_text):
# 	command_history.append(new_text)
# 	_history_pointer = null
# 	var inputs = Array(new_text.split(' '))
# 	var command_name = inputs.pop_front()
# 	Global.Debug.command(command_name, inputs, 'Query: ' + new_text)
# 	CommandLine.text = ''
