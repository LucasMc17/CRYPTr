class_name DebugStats
extends PanelContainer
## Debug scene to display key performance data and status indicators to the user (as a developer, rather than a player)

## The game's current frames per second.
var fps : String:
	set(val):
		fps_label.text = val
		fps = val

## Label scene for visually indicating the game's current frames per second.
@onready var fps_label = %FPSValue

func _process(delta):
	fps = "%.2f" % (1.0 / delta)