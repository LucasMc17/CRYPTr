# @tool
class_name MapNode extends ColorRect

var map_node_scene = preload('./map_node.tscn')

signal encounter_clicked(encounter : EncounterRes, scene : MapNode)

var y_cell_size := 50
var x_cell_size := 50.0

@export var ENCOUNTER: EncounterRes

@export var next_file_offset := Vector2(50, 150)

@onready var CHILDREN_LINE_HOLDER := %ChildrenLineHolder
@onready var PARENT_LINE := %ParentLine

func resize_lines(x : float):
	if PARENT_LINE.points:
		PARENT_LINE.points[1].x = -x + 20
		PARENT_LINE.points[2].x = -x + 20

func update_colors():
	if ENCOUNTER.VISITED:
		modulate = "#0000FF"
		PARENT_LINE.z_index = 10

func _ready():
	if ENCOUNTER.PARENT:
		PARENT_LINE.width = 5
		PARENT_LINE.add_point(Vector2.ZERO)
		PARENT_LINE.add_point(Vector2(-x_cell_size + 20, 0))
		PARENT_LINE.add_point(Vector2(-x_cell_size + 20, -ENCOUNTER.relative_y * y_cell_size))

func _gui_input(event):
	if Player.CURRENT_ENCOUNTER:
		if Player.CURRENT_ENCOUNTER.BRANCHES.has(ENCOUNTER) and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			encounter_clicked.emit(ENCOUNTER, self)
	elif Player.ENCOUNTER_MAP == self.ENCOUNTER and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		encounter_clicked.emit(ENCOUNTER, self)