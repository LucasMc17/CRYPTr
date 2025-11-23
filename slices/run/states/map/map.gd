extends Switchable

@onready var MAP_INSTANCE := %MapInstance

var SHOULD_CREATE_NEW_MAP := true

func _ready():
	if SHOULD_CREATE_NEW_MAP:
		MAP_INSTANCE.init_map(0, 2)