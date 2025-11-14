@tool
extends GridContainer

var map_cell_scene = preload('./test_map_cell.tscn')
var file_scene = preload('./map_node.tscn')

@export var ENCOUNTER_MAP : EncounterRes
@export var CURRENT_ENCOUNTER : EncounterRes
@export var DEPTH_LIMIT := INF

var GRID_INFO : Dictionary

@export_category("DEBUG")
@export var RESET_BUTTON := true:
	set(val):
		for child in get_children():
			child.queue_free()
		ENCOUNTER_MAP = EncounterRes.new("MATCH", 3, null, 0, 1)
		CURRENT_ENCOUNTER = ENCOUNTER_MAP
		GRID_INFO = populate_grid_info()
		build_grid_map()

func _ready():
	ENCOUNTER_MAP = EncounterRes.new("MATCH", 3, null, 0, 4)
	CURRENT_ENCOUNTER = ENCOUNTER_MAP
	GRID_INFO = populate_grid_info()
	build_grid_map()

class cell_object:
	var encounter : EncounterRes

	func to_object():
		return {
			"encounter": encounter
		}

func populate_grid_info() -> Dictionary:
	var result = {
		"total_depth": 0,
		"encounter_info": []
	}
	if CURRENT_ENCOUNTER:
		result.total_depth = CURRENT_ENCOUNTER.recursive_depth_trace()
		result.encounter_info = CURRENT_ENCOUNTER.recursively_get_coords()
	return result

func convert_coords(coords : Vector2) -> int:
	return coords.y * columns + coords.x

func build_grid_map():
	if CURRENT_ENCOUNTER:
		columns = CURRENT_ENCOUNTER.DISTANCE_FROM_END + 1
		var cell_count = columns * GRID_INFO.total_depth
		var cell_list = range(cell_count).map(func (cell): return cell_object.new())
		for obj in GRID_INFO.encounter_info:
			var index = convert_coords(obj.coords)
			cell_list[index].encounter = obj.encounter
		for obj in cell_list:
			var cell = map_cell_scene.instantiate()
			if obj.encounter != null:
				var file = file_scene.instantiate()
				file.ENCOUNTER = obj.encounter
				cell.add_child(file)
			print(cell_list.map(func(cell): return cell.to_object()))
			add_child(cell)