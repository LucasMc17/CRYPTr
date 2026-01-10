extends Switchable

## The currently selected hook.
var _selected_hook : Hook:
	set(val):
		if val:
			_hook_config_windows.visible = true
			_none_selected_label.visible = false
		else:
			_hook_config_windows.visible = false
			_none_selected_label.visible = true
		_selected_hook = val

@onready var _hook_config_windows := %HookConfigWindows
@onready var _hook_text := %HookText
@onready var _none_selected_label := %NoneSelectedLabel
@onready var _function_window := %FunctionWindow

func _ready():
	Events.refresh_hooks.connect(_on_hooks_updated)
	_function_window.populate()


func _on_hook_selected(hook : Hook):
	_selected_hook = hook
	_hook_text.hook = hook
	_hook_text.allow_config = true
	_hook_text.refresh_text()
	_function_window.refresh(hook)


func _on_hooks_updated():
	_function_window.refresh(_selected_hook)