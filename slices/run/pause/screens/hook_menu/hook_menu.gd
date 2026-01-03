extends Switchable

## The currently selected hook.
var _selected_hook : Hook:
	set(val):
		if val:
			_hook_config_windows.visible = true
		else:
			_hook_config_windows.visible = false
		_selected_hook = val

@onready var _hook_config_windows := %HookConfigWindows
@onready var _hook_text := %HookText

func _on_hook_selected(hook : Hook):
	_selected_hook = hook
	_hook_text.hook = hook
	_hook_text.allow_config = true
	_hook_text.refresh_text()