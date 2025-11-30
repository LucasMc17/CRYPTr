extends UISwitcher

func _ready():
	Events.new_run_started.connect(_on_new_run_started)
	super()


func _on_new_run_started() -> void:
	transition('RunScreen')