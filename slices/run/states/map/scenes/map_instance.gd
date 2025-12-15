class_name MapInstance
extends GridContainer
## The actual instance of the map scene in the map Switchable of the run UI Switcher.

## Custom signal emitted whenever the map is resized. Exclusively emitted when the `_on_resized` func executes.
signal map_resized(new_column_width : float)

# TODO: Decide if we need this to work
## Maximum number of layers of tree to show. NOTE: Not currently in use, to be integrated later.
const _DEPTH_LIMIT := INF
## Preloaded map node scene.
const _MAP_NODE = preload('res://slices/run/states/map/scenes/map_node.tscn')
## Preloaded map cell scene.
const _MAP_CELL := preload('./map_cell.tscn')
## Root MapNode scene of the current map instance.
var _root_node : MapNode

## Main function to create a NEW encounter map and populate it onto the grid.
func init_map(session_depth : int, length_limit : int) -> void:
	# First, create the encounter resources
	Player.encounter_map = EncounterRes.new("MATCH", 3, null, session_depth, 0, length_limit)
	# Second, create a tree of actual 2D scenes, mirroring the structure of the resrouce itself
	_root_node = _MAP_NODE.instantiate()
	_root_node.encounter_resource = Player.encounter_map
	_build_grid_map()
	# Fourth, place the scenes from the tree in their correct spots throughout the grid
	_populate_scenes(_root_node)


## Main function to RESUME an existing encounter map and populate it onto the grid.
func resume_map() -> void:
	_root_node = _MAP_NODE.instantiate()
	_root_node.encounter_resource = Player.encounter_map
	_build_grid_map()
	_populate_scenes(_root_node)
	_root_node.update_colors()


## Updates encounter information with latest info after new encounter is selected.
func _on_encounter_clicked(map_node : MapNode) -> void:
	map_node.encounter_resource.visited = true

	if Player.current_encounter:
		for branch in Player.current_encounter.branches:
			if branch != map_node.encounter_resource:
				branch.bypass()
	
	Player.current_encounter = map_node.encounter_resource
	Events.match_started.emit({"encounter": map_node.encounter_resource})
	_root_node.update_colors()


## Uses the information within the root MapNode to instantiate and place MapNode scenes all throughout the grid.
func _populate_scenes(node : MapNode) -> void:
	var index = _convert_coords(Vector2i(node.x, node.y))
	var cell = get_child(index)
	map_resized.connect(node.resize_lines)
	node.x_cell_size = size.x / columns
	node.encounter_clicked.connect(_on_encounter_clicked)
	node.z_index = node.encounter_resource.distance_from_end
	cell.add_child(node)

	for branch in node.branches:
		_populate_scenes(branch)


## Utility functtion to turn a set of coordinates into an index for the grid.
func _convert_coords(coords : Vector2i) -> int:
	return coords.y * columns + coords.x


## Builds out the grid to the correct size by populating empty controls.
func _build_grid_map():
	if Player.encounter_map:
		columns = Player.encounter_map.distance_from_end + 1
		var cell_count = columns * Player.encounter_map.recursive_depth_trace()
		for i in range(cell_count):
			var cell = _MAP_CELL.instantiate()
			add_child(cell)


func _on_resized():
	map_resized.emit(size.x / columns)
