@tool
extends ColorRect

var map_node_scene = preload('./map_node.tscn')

@export var ENCOUNTER: EncounterRes

@export var next_file_offset := Vector2(150, 150)

@onready var PARENT_LINE_HOLDER := %ParentLineHolder
@onready var CHILDREN_LINE_HOLDER := %ChildrenLineHolder

func recurive_depth_trace(encounter: EncounterRes) -> int:
	var count = 1
	for branch in encounter.branches:
		count += recurive_depth_trace(branch)
	return count

func clear_children():
	for child in CHILDREN_LINE_HOLDER.get_children():
		print(child)
		child.free()

func build():
	var line_depth = 1
	for i in range(ENCOUNTER.branches.size()):
		var encounter : EncounterRes = ENCOUNTER.branches[i]
		var line = Line2D.new()
		line.width = 5
		if i > 0:
			line_depth += recurive_depth_trace(ENCOUNTER.branches[i - 1])
		var y_depth = line_depth * next_file_offset.y
		var x_depth = 16 + next_file_offset.x
		var point_one = Vector2(0, 0)
		var point_two = Vector2(0, y_depth)
		var point_three = Vector2(x_depth, y_depth)
		line.points = [point_one, point_two, point_three]
		CHILDREN_LINE_HOLDER.add_child(line)
		var node = map_node_scene.instantiate()
		node.ENCOUNTER = encounter
		node.position = point_three + Vector2(0, -50)
		line.add_child(node)
		node.build()