extends GridContainer

var map_cell_scene = preload('./map_cell.tscn')

@export var DEPTH_LIMIT := INF

signal map_resized(new_column_width : float)

class TreeNode:
	var scene : MapNode
	var branches : Array
	var x := 0
	var y := 0

	func _init(encounter : EncounterRes, parent : Variant):
		var file_scene = load('res://slices/run/states/map/scenes/map_node.tscn')
		scene = file_scene.instantiate()
		scene.ENCOUNTER = encounter
		if parent is TreeNode:
			x = parent.x + 1
			y = parent.y + encounter.relative_y
		branches = encounter.BRANCHES.map(func (enc): return TreeNode.new(enc, self))

	func to_object():
		return {
			"scene": scene,
			"branches": branches.map(func (obj): return obj.to_object())
		}
	
	func update_colors():
		scene.update_colors()
		for branch in branches:
			branch.update_colors()

var MAP_TREE : TreeNode

func populate_scenes(tree : TreeNode):
	var index = convert_coords(Vector2(tree.x, tree.y))
	var cell = get_child(index)
	map_resized.connect(tree.scene.resize_lines)
	tree.scene.x_cell_size = size.x / columns
	tree.scene.encounter_clicked.connect(_on_encounter_clicked)
	tree.scene.z_index = tree.scene.ENCOUNTER.DISTANCE_FROM_END
	cell.add_child(tree.scene)
	for branch in tree.branches:
		populate_scenes(branch)

func init_map(session_depth : int, length_limit : int):
	# First, create the encounter resources
	Player.ENCOUNTER_MAP = EncounterRes.new("MATCH", 3, null, session_depth, 0, length_limit)
	# Second, create a tree of actual 2D scenes, mirroring the structure of the resrouce itself
	MAP_TREE = TreeNode.new(Player.ENCOUNTER_MAP, null)
	# Third, create the grid of nodes
	build_grid_map()
	# Fourth, place the scenes from the tree in their correct spots throughout the grid
	populate_scenes(MAP_TREE)

func _ready():
	init_map(0, 2)

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
		for i in range(cell_count):
			var cell = map_cell_scene.instantiate()
			add_child(cell)

func _on_resized():
	map_resized.emit(size.x / columns)

func _on_encounter_clicked(map_node : MapNode):
	map_node.ENCOUNTER.VISITED = true
	if Player.CURRENT_ENCOUNTER:
		for branch in Player.CURRENT_ENCOUNTER.BRANCHES:
			if branch != map_node.ENCOUNTER:
				# branch.BYPASSED = true
				branch.bypass()
				# branch.SCENE.update_colors()
	Player.CURRENT_ENCOUNTER = map_node.ENCOUNTER
	Events.match_started.emit(map_node.ENCOUNTER)
	MAP_TREE.update_colors()