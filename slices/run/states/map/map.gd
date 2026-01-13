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
	if DebugNode.command_args.is_debug_map:
		DebugNode.print('MAP accessed directly', 1)
