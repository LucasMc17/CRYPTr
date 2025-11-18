# @tool
class_name MapNode extends ColorRect

var map_node_scene = preload('./map_node.tscn')

signal encounter_clicked(encounter : EncounterRes, scene : MapNode)

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

func update_colors():
	if ENCOUNTER.VISITED:
		self_modulate = "#0000FF"
	for child in CHILDREN_LINE_HOLDER.get_children():
		if child.ENCOUNTER.VISITED:
			child.self_modulate = '#0000FF'

func _ready():
	for branch in ENCOUNTER.BRANCHES:
		var line = MapLine.new()
		line.ENCOUNTER = branch
		CHILDREN_LINE_HOLDER.add_child(line)
		line.width = 5
		line.add_point(Vector2.ZERO)
		line.add_point(Vector2(0, branch.relative_y * y_cell_size - 20))
		line.add_point(Vector2(x_cell_size, branch.relative_y * y_cell_size - 20))
		update_colors()

func _gui_input(event):
	if Player.CURRENT_ENCOUNTER:
		if Player.CURRENT_ENCOUNTER.BRANCHES.has(ENCOUNTER) and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			encounter_clicked.emit(ENCOUNTER, self)
	elif Player.ENCOUNTER_MAP == self.ENCOUNTER and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		encounter_clicked.emit(ENCOUNTER, self)