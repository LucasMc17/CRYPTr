extends UISwitcher

func _ready():
	Events.new_run_started.connect(on_new_run_started)
	super()

func on_new_run_started() -> void:
	transition('RunScreen')