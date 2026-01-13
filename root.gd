extends UISwitcher

func _ready():
	Events.new_run_started.connect(_on_new_run_started)
	Events.quit_to_menu.connect(_on_quit_to_menu)
	super()
	if DebugNode.is_debug_instance():
		Events.emit_new_run_started()
		if DebugNode.is_debug_encounter():
			Events.emit_match_started.call_deferred(EncounterRes.new("MATCH", 0, null, 0, 0, 0))


func _on_new_run_started(_params) -> void:
	transition('RunScreen')


func _on_quit_to_menu(_params) -> void:
	transition('StartScreen')
	Player.reset_run()