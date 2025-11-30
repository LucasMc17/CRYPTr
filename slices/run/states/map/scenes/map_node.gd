class_name MapNode
extends ColorRect
## UI scene represengint a single file (node) in the map. Also includes the line extending from this node's parent to itself.

## Emitted when the encounter is selected, must be a branch of the player's current node, or else the signal will not emit.
signal encounter_clicked(scene : MapNode)

## The encounter resource used to populate information about this node in the map.
@export var encounter_resource: EncounterRes

# NOTE: no reason these couldn't be a vector2i. Probably a lot of improvements to be made here.
## Current y dimension of the parent control, used to calculate height of the parent line.
const y_cell_size := 50
## Current x dimension of the parent control, used to calculate width of parent line.
var x_cell_size := 50.0

@onready var parent_line := %ParentLine

func _ready():
	if encounter_resource.parent:
		parent_line.width = 5
		parent_line.add_point(Vector2.ZERO)
		parent_line.add_point(Vector2(-x_cell_size + 20, 0))
		parent_line.add_point(Vector2(-x_cell_size + 20, -encounter_resource.relative_y * y_cell_size))


func _gui_input(event):
	if Player.current_encounter:
		if Player.current_encounter.branches.has(encounter_resource) and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			encounter_clicked.emit(self)
	elif Player.encounter_map == self.encounter_resource and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		encounter_clicked.emit(self)


## Method for resizing the parent lines when the map's dimensions change. Takes in the new x dimension of the cell.
func resize_lines(x : float) -> void:
	if parent_line.points:
		parent_line.points[1].x = -x + 20
		parent_line.points[2].x = -x + 20


## Method for updaying the color of the node and it's parent line.
func update_colors() -> void:
	if encounter_resource.visited:
		modulate = "#0000FF"
		parent_line.z_index = 10
	elif encounter_resource.bypassed:
		modulate = "#999999"