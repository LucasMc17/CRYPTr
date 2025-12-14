extends UISwitcher

func _ready():
	Events.new_run_started.connect(_on_new_run_started)
	Events.quit_to_menu.connect(_on_quit_to_menu)
	super()


func _on_new_run_started() -> void:
	transition('RunScreen')


func _on_quit_to_menu() -> void:
	transition('StartScreen')
	Player.reset_run()