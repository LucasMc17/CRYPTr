extends Switchable
## Switchable representing the map view on the current run.

@onready var map_instance := %MapInstance

## Boolean represengint whether the map should generate a new map or recreate the existing on on rendering.
var _should_create_new_map := true

# TODO: This is so ugly, way too many places default params are initiated. Gotta think of a more elegant solution
func _init():
	DEFAULT_PARAMS = { "new_map": true }


func _ready():
	if _should_create_new_map:
		map_instance.init_map(0, 3)
	else:
		map_instance.resume_map()

		
func setup(init_obj := { "new_map": false }):
	_should_create_new_map = init_obj.new_map