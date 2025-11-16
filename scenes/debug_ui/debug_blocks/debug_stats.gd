class_name DebugStats extends PanelContainer

@onready var FPS = %FPSValue
var fps : String:
	set(val):
		FPS.text = val
		fps = val

# func _ready():
# 	Global.Debug.PLAYER_STATUS = self
# 	if Global.Debug.debug_override == "DEFER":
# 		visible = Global.Debug.show_player_status

func _process(delta):
	fps = "%.2f" % (1.0 / delta)