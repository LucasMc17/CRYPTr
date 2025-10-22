extends UIState

func _ready():
	Events.new_run_started.connect(func (): transition("RunScreen"))
