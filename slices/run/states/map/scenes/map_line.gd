@tool
extends Line2D

var PARENT_NODE : Control
var TARGET_NODE : Control

func _process(_delta):
	points[0] = PARENT_NODE.global_position
	points[2] = TARGET_NODE.global_position
	points[1] = Vector2(PARENT_NODE.global_position.x, TARGET_NODE.global_position.y)