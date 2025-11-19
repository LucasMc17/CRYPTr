# @tool
extends GridContainer

var map_cell_scene = preload('./map_cell.tscn')
var file_scene = preload('./map_node.tscn')

@export var DEPTH_LIMIT := INF

signal map_resized(new_column_width : float)

## Debug button for generating encounter maps in the editor, solely for testing purposes
# @export_category("DEBUG")
# @export var RESET_BUTTON := true:
# 	set(val):
# 		for child in get_children():
# 			child.queue_free()
# 		init_map(0, 2)

func init_map(session_depth : int, length_limit : int):
	Player.ENCOUNTER_MAP = EncounterRes.new("MATCH", 3, null, session_depth, 0, length_limit)
	build_grid_map()

func _ready():
	init_map(0, 2)

class CellObject:
	var encounter : EncounterRes

	func to_object():
		return {
			"encounter": encounter.to_object()
		}

func convert_coords(coords : Vector2) -> int:
	return coords.y * columns + coords.x

func recursively_build_files(cell_list: Array, encounter: EncounterRes, coords: Vector2):
	var index = convert_coords(coords)
	cell_list[index].encounter = encounter
	for branch in encounter.BRANCHES:
		recursively_build_files(cell_list, branch, Vector2(coords.x + 1, coords.y + branch.relative_y))

func build_grid_map():
	if Player.ENCOUNTER_MAP:
		columns = Player.ENCOUNTER_MAP.DISTANCE_FROM_END + 1
		var cell_count = columns * Player.ENCOUNTER_MAP.recursive_depth_trace()
		var cell_list : Array = range(cell_count).map(func (cell): return CellObject.new())
		recursively_build_files(cell_list, Player.ENCOUNTER_MAP, Vector2.ZERO)
		for obj in cell_list:
			var cell = map_cell_scene.instantiate()
			if obj.encounter != null:
				var file = file_scene.instantiate()
				file.ENCOUNTER = obj.encounter
				map_resized.connect(file.resize_lines)
				file.x_cell_size = size.x / columns
				file.encounter_clicked.connect(_on_encounter_clicked)
				file.z_index = obj.encounter.DISTANCE_FROM_END
				cell.add_child(file)
			add_child(cell)

func _on_resized():
	map_resized.emit(size.x / columns)

func _on_encounter_clicked(encounter : EncounterRes, map_node : MapNode):
	encounter.VISITED = true
	Player.CURRENT_ENCOUNTER = encounter
	Events.match_started.emit(encounter)
	map_node.update_colors()