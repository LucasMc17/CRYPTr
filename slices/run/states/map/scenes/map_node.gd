# @tool
class_name MapNode extends ColorRect

var map_node_scene = preload('./map_node.tscn')

var y_cell_size := 50
var x_cell_size := 50.0

@export var ENCOUNTER: EncounterRes

@export var next_file_offset := Vector2(50, 150)

@onready var PARENT_LINE_HOLDER := %ParentLineHolder
@onready var CHILDREN_LINE_HOLDER := %ChildrenLineHolder

func clear_children():
	for child in CHILDREN_LINE_HOLDER.get_children():
		child.free()

func resize_lines(x : float):
	for line in CHILDREN_LINE_HOLDER.get_children():
		line.points[2].x = x

func _ready():
	for branch in ENCOUNTER.branches:
		var line = Line2D.new()
		CHILDREN_LINE_HOLDER.add_child(line)
		line.width = 5
		line.add_point(Vector2.ZERO)
		line.add_point(Vector2(0, branch.relative_y * y_cell_size - 20))
		line.add_point(Vector2(x_cell_size, branch.relative_y * y_cell_size - 20))