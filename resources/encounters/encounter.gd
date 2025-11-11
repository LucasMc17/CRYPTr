class_name EncounterRes extends Resource

# EXPORTS
@export_group("Encounter Info")
@export_enum("MATCH", "SHOP", "NEW_CGRAPH", "NEW_EXE", "REDISTRIBUTE") var type : String
@export var security_level := 0
# @export var current_position := false

@export_group("Branches")
@export var parent : EncounterRes
# @export var boss_branch : BossEncounterResource
@export var branches : Array[EncounterRes] = []

func to_object() -> Dictionary:
	return {
		"type": type,
		"security_level": security_level,
		"parent": parent,
		"branches": branches.map(func (enc : EncounterRes): return enc.to_object())
	}

func _init(encounter_type: String, max_branches: int, parent_node : EncounterRes, sec_level : int, distance_from_end: int):
	self.type = encounter_type
	self.parent = parent_node
	self.security_level = sec_level
	if distance_from_end > 0:
		for i in range(randi_range(1, max_branches)):
			branches.append(EncounterRes.new("MATCH", max_branches, self, security_level + 1, distance_from_end - 1))