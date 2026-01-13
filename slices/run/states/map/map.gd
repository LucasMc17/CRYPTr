extends Switchable
## Switchable representing the map view on the current run.

@onready var map_instance := %MapInstance

## Boolean represengint whether the map should generate a new map or recreate the existing on on rendering.
var new_map := true

func _ready():
	if new_map:
		map_instance.init_map(0, 3)
	else:
		map_instance.resume_map()
	if DebugNode.is_debug_map():
		# TODO: Call deferred necessary here because the console has not finished rendering itself when this runs. 
		# In future, might want to set up a log queue to handle logs that hit the console before its ready.
		DebugNode.print_n.call_deferred('MAP accessed directly')
