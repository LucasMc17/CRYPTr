class_name DebugConsole
extends PanelContainer
## Debug scene for showing printed variables within the game program and for handling tester input
## via text commands.

## An array repredsenting the full history of inputted commands.
var command_history := []
## A pointer to track user's position in the command history while toggling through recent commands with up and down.
var _history_pointer
## Logic module for handling command input.
var commands = CommandModule.new()

@onready var history := %History
@onready var command_line := %CommandLine

func _ready():
	print(DebugNode.print_queue)
	DebugNode.debug_console = self
	for message in DebugNode.print_queue:
		DebugNode.print(message)
	Events.command_help.connect(func (_params): commands.help())
	Events.command_clear.connect(func (_params): clear())
	Events.command_echo.connect(func (params): DebugNode.print(' '.join(params)))
	Events.command_exit.connect(func (_params): get_tree().quit(0))
	Events.command_restart.connect(func (_params):
		get_tree().reload_current_scene()
		Player.reset_run()
	)


func _input(_event):
	if command_line.has_focus():
		if Input.is_action_just_pressed("up"):
			if _history_pointer == 0:
				return
			if _history_pointer != null and _history_pointer > 0:
				_get_from_history(_history_pointer - 1)
				return
			elif !_history_pointer and command_history.size() > 0:
				_get_from_history(command_history.size() - 1)
				return
		elif Input.is_action_just_pressed("down"):
			if _history_pointer != null and _history_pointer < command_history.size() - 1:
				_get_from_history(_history_pointer + 1)
				return
		elif Input.is_action_just_pressed("escape"):
			get_window().gui_release_focus()
			get_viewport().set_input_as_handled()


## Retrieves a command from history and fills the input line with it.
func _get_from_history(pointer : int) -> void:
	_history_pointer = pointer
	command_line.text = command_history[pointer]
	command_line.call_deferred("set_caret_column", 1000)


## clears the terminal.
func clear() -> void:
	history.text = ''


func _on_history_gui_input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		command_line.call_deferred("grab_focus")


func _on_command_line_text_submitted(new_text) -> void:
	command_history.append(new_text)
	_history_pointer = null
	commands.run(new_text)
	command_line.text = ''


## Logs a single data point or a sequence as an array to the terminal.
func log(message : Variant) -> void:
		# NOTE: this could get much more in depth but this will do for now
		print(message)
		if message is Array:
			for i in message.size():
				var element = message[i]
				var prefix = ''
				if i == 0:
					prefix = '> '
				history.text += '\n' + prefix + str(element)
		else:
			history.text += '\n' + '>' + str(message)
