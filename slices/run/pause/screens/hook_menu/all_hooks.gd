extends PanelContainer

## Signal for passing selected Hook up to menu level.
signal hook_selected(hook : Hook)

func _on_hook_selected(hook : Hook):
	hook_selected.emit(hook)