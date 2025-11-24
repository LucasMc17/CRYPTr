class_name EncounterRes extends Resource

# EXPORTS
@export_group("Encounter Info")
@export var NAME : String = '0_0_TEST'
@export_enum("MATCH", "SHOP", "NEW_CGRAPH", "NEW_EXE", "REDISTRIBUTE") var TYPE : String
@export var SESSION_DEPTH := 0
@export var SECURITY_LEVEL := 0
@export var DISTANCE_FROM_END := 0
@export var VISITED := false
@export var BYPASSED := false
# @export var current_position := false

@export_group("Branches")
@export var PARENT : EncounterRes
# @export var boss_branch : BossEncounterResource
@export var BRANCHES : Array[EncounterRes] = []

var relative_y : int
var alphabet := "abcdefghijklmnopqrstuvwxyz0123456789"

var SCENE : MapNode

func to_object() -> Dictionary:
	return {
		"NAME": NAME,
		"TYPE": TYPE,
		"SECURITY_LEVEL": SECURITY_LEVEL,
		"SESSION_DEPTH": SESSION_DEPTH,
		# "PARENT": PARENT,
		"BRANCHES": BRANCHES.map(func (enc : EncounterRes): return enc.to_object()),
		"DISTANCE_FROM_END": DISTANCE_FROM_END,
		"relative_y": relative_y
	}

func recursive_depth_trace() -> int:
	var count = 1
	for branch in BRANCHES:
		count += branch.recursive_depth_trace()
	return count

func bypass():
	BYPASSED = true
	for branch in BRANCHES:
		branch.bypass()

func _init(encounter_type: String, max_branches: int, parent_node : EncounterRes, session_depth : int, sec_level : int, distance_from_end: int, sibling_index := 0):
	var name = str(sec_level) + '_' + str(sibling_index) + '_'
	for i in range(5):
		var letter = alphabet[randi_range(0, alphabet.length() -1)]
		name += letter
	self.NAME = name
	self.TYPE = encounter_type
	self.DISTANCE_FROM_END = distance_from_end
	self.PARENT = parent_node
	self.SESSION_DEPTH = session_depth
	if !parent_node:
		self.relative_y = 0
	else:
		self.relative_y = 1
		for sibling in parent_node.BRANCHES:
			if sibling == self:
				break
			else:
				self.relative_y += sibling.recursive_depth_trace()
	self.SECURITY_LEVEL = sec_level
	if distance_from_end > 0:
		for i in range(randi_range(1, max_branches)):
			BRANCHES.append(EncounterRes.new("MATCH", max_branches, self, self.SESSION_DEPTH, SECURITY_LEVEL + 1, DISTANCE_FROM_END - 1, i))
