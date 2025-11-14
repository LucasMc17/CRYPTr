class_name EncounterRes extends Resource

# EXPORTS
@export_group("Encounter Info")
@export_enum("MATCH", "SHOP", "NEW_CGRAPH", "NEW_EXE", "REDISTRIBUTE") var type : String
@export var security_level := 0
@export var DISTANCE_FROM_END := 0
# @export var current_position := false

@export_group("Branches")
@export var parent : EncounterRes
# @export var boss_branch : BossEncounterResource
@export var branches : Array[EncounterRes] = []

func to_object() -> Dictionary:
	return {
		"type": type,
		"security_level": security_level,
		# "parent": parent,
		"branches": branches.map(func (enc : EncounterRes): return enc.to_object()),
		"distance_from_end": DISTANCE_FROM_END
	}

# TODO: These two can almost certainly be joined later to save processing time.
func recursive_depth_trace() -> int:
	var count = 1
	for branch in branches:
		count += branch.recursive_depth_trace()
	return count

func recursively_get_coords(coord_array := [], x := 0, y:= 0):
	coord_array.append({
		"encounter": self,
		"coords": Vector2(x, y)
	})
	x += 1
	y += 1
	for i in range(branches.size()):
		var branch = branches[i]
		if i > 0:
			y += branches[i - 1].recursive_depth_trace()
		branch.recursively_get_coords(coord_array, x, y)
	return coord_array

func _init(encounter_type: String, max_branches: int, parent_node : EncounterRes, sec_level : int, distance_from_end: int):
	self.type = encounter_type
	self.DISTANCE_FROM_END = distance_from_end
	self.parent = parent_node
	self.security_level = sec_level
	if distance_from_end > 0:
		for i in range(randi_range(1, max_branches)):
			branches.append(EncounterRes.new("MATCH", max_branches, self, security_level + 1, distance_from_end - 1))
