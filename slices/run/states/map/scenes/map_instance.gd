class_name MapInstance
extends GridContainer
## The actual instance of the map scene in the map Switchable of the run UI Switcher.

## Custom signal emitted whenever the map is resized. Exclusively emitted when the `_on_resized` func executes.
signal map_resized(new_column_width : float)

## Maximum number of layers of tree to show. NOTE: Not currently in use, to be integrated later.
const _DEPTH_LIMIT := INF

## Map cell scene to be instantiated appropriately throughout grid.
var _map_cell_scene := preload('./map_cell.tscn')
## Current map tree object, generated when scene is created.
var _map_tree : TreeNode

## Main function to create a NEW encounter map and populate it onto the grid.
func init_map(session_depth : int, length_limit : int) -> void:
	# First, create the encounter resources
	Player.ENCOUNTER_MAP = EncounterRes.new("MATCH", 3, null, session_depth, 0, length_limit)
	# Second, create a tree of actual 2D scenes, mirroring the structure of the resrouce itself
	_map_tree = TreeNode.new(Player.ENCOUNTER_MAP, null)
	# Third, create the grid of nodes
	_build_grid_map()
	# Fourth, place the scenes from the tree in their correct spots throughout the grid
	_populate_scenes(_map_tree)


## Main function to RESUME an existing encounter map and populate it onto the grid.
func resume_map() -> void:
	_map_tree = TreeNode.new(Player.ENCOUNTER_MAP, null)
	_build_grid_map()
	_populate_scenes(_map_tree)
	_map_tree.update_colors()


## Updates encounter information with latest info after new encounter is selected.
func _on_encounter_clicked(map_node : MapNode) -> void:
	map_node.encounter_resource.visited = true

	if Player.CURRENT_ENCOUNTER:
		for branch in Player.CURRENT_ENCOUNTER.branches:
			if branch != map_node.encounter_resource:
				branch.bypass()
	
	Player.CURRENT_ENCOUNTER = map_node.encounter_resource
	Events.match_started.emit(map_node.encounter_resource)
	_map_tree.update_colors()


## Uses the information within the MapTree object to instantiate and place MapNode scenes all throughout the grid.
func _populate_scenes(tree : TreeNode) -> void:
	var index = _convert_coords(Vector2i(tree.x, tree.y))
	var cell = get_child(index)
	map_resized.connect(tree.scene.resize_lines)
	tree.scene.x_cell_size = size.x / columns
	tree.scene.encounter_clicked.connect(_on_encounter_clicked)
	tree.scene.z_index = tree.scene.encounter_resource.distance_from_end
	cell.add_child(tree.scene)

	for branch in tree.branches:
		_populate_scenes(branch)


## Utility functtion to turn a set of coordinates into an index for the grid.
func _convert_coords(coords : Vector2i) -> int:
	return coords.y * columns + coords.x


## Builds out the grid to the correct size by populating empty controls.
func _build_grid_map():
	if Player.ENCOUNTER_MAP:
		columns = Player.ENCOUNTER_MAP.distance_from_end + 1
		var cell_count = columns * Player.ENCOUNTER_MAP.recursive_depth_trace()
		for i in range(cell_count):
			var cell = _map_cell_scene.instantiate()
			add_child(cell)


func _on_resized():
	map_resized.emit(size.x / columns)

# TODO: There's just no reason this logic can't be handled by the root node itself. Something to refactor later.
## Temporary class used to represent a single node in the tree structure of the map. Used for recursive functions in calculating the position of the nodes
## and coloring them after they are accessed or bypassed.
class TreeNode:
	## Corresponding MapNode scene.
	var scene : MapNode
	## Child nodes of the one this object represents.
	var branches : Array
	## X position of the scene within the map grid.
	var x := 0
	## Y position of the scene within the map grid.
	var y := 0

	func _init(encounter : EncounterRes, parent : Variant):
		var file_scene = load('res://slices/run/states/map/scenes/map_node.tscn')
		scene = file_scene.instantiate()
		scene.encounter_resource = encounter
		if parent is TreeNode:
			x = parent.x + 1
			y = parent.y + encounter.relative_y
		branches = encounter.branches.map(func (enc): return TreeNode.new(enc, self))

	# TODO: Gotta make a utility function for this so I don't have to rewrite it on every custom class.
	## Utility function to convert this object to a dictionary for printing purposes.
	func to_object() -> Dictionary:
		return {
			"scene": scene,
			"branches": branches.map(func (obj): return obj.to_object())
		}
	
	## Recurively colors scenes and all scenes inheriting from this one.
	func update_colors() -> void:
		scene.update_colors()
		for branch in branches:
			branch.update_colors()