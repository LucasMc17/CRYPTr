extends Switchable
## Switchable representing the map view on the current run.

@onready var map_instance := %MapInstance

## Boolean represengint whether the map should generate a new map or recreate the existing on on rendering.
# var _should_create_new_map := true

func _init():
	params = { "new_map": true }


func _ready():
	if params.new_map:
	# if _should_create_new_map:
		map_instance.init_map(0, 3)
	else:
		map_instance.resume_map()
