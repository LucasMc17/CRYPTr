class_name EncounterRes
extends Resource
## Custom resource representing a single encounter in a tree of encounters (a 'Map').
##
## Contains relevant information about it's type, position, special characteristics, and references to it's branches (child EncounterRes instances).
## Also contains helper functions to determine the physicaly position of its scene within the map_instance.tscn file

@export_group("Encounter Info")
## The locally unique name of the encounter, consisting of its `security_level`, index among its sibling branches, and a randomized string
@export var name : String = '0_0_TEST'
## The type of the encounter, such as MATCH, SHOP, etc.
@export_enum("MATCH", "SHOP", "NEW_CGRAPH", "NEW_EXE") var type = "MATCH"
## The depth of the current encounter tree. Increments with each new encounter tree, not when moving from one encounter to one of its branches.
@export var session_depth := 0
## The level of the current encounter within its encounter tree. The root of an encounter tree will always have a security level of 0, whereas
## it's branches will have a level of 1, their branches a level of 2, etc.
@export var security_level := 0
## The monetary reward for completing the encounter.
@export var reward : int

@export_group("Branches")
## The parent encounter instance of the current encounter instance. This encounter resource will be included in the `branches` array of its parent.
@export var parent : EncounterRes
# @export var boss_branch : BossEncounterResource
## The child encounters of this encounter resource. Each will list this encounter resource as it's `parent`
@export var branches : Array[EncounterRes] = []

## The relative offset of this encounter from it's parent, when represented in the game's map screen. Calculated in the `_init` method.
var relative_y : int
## The distance from this encounter to the encounter tree's lowest extremity. At the deepest level of an encounter tree, the value will be 0.
var distance_from_end := 0
## A boolean representing whether the player has already visited this encounter.
var visited := false
## A boolean representing whether the player has bypassed this encounter (and by extension it's branches recursively) without visiting it.
var bypassed := false
## Utility Callable to convert the resource to a Dictionary for printing purposes.
var to_dictionary : Callable = DebugNode.make_to_printable_method(self, [
		"name",
		"type",
		"security_level",
		"session_depth",
		"parent",
		"branches",
		"distance_from_end",
		"relative_y"
])

func _init(
		enc_type: String,
		enc_max_branches: int,
		enc_parent_node : EncounterRes,
		enc_session_depth : int,
		enc_security_level : int,
		enc_distance_from_end: int, 
		enc_sibling_index := 0
	):
	var enc_name = str(enc_security_level) + '_' + str(enc_sibling_index) + '_'
	for i in range(5):
		var letter = Constants.ALPHANUMERIC[randi_range(0, Constants.ALPHANUMERIC.length() -1)]
		enc_name += letter
	self.name = enc_name
	self.type = enc_type
	self.distance_from_end = enc_distance_from_end
	self.parent = enc_parent_node
	self.session_depth = enc_session_depth
	reward = enc_security_level + 3 - randi_range(0, 2)
	if !enc_parent_node:
		self.relative_y = 0
	else:
		self.relative_y = 1
		for sibling in enc_parent_node.branches:
			if sibling == self:
				break
			else:
				self.relative_y += sibling.recursive_depth_trace()
	self.security_level = enc_security_level
	if enc_distance_from_end > 0:
		for i in range(randi_range(1, enc_max_branches)):
			branches.append(EncounterRes.new("MATCH", enc_max_branches, self, self.session_depth, enc_security_level + 1, enc_distance_from_end - 1, i))


## Recursively calculates the total number of nodes in the encounter tree from this point downwards, including the current encounter. 
func recursive_depth_trace() -> int:
	var count = 1
	for branch in branches:
		count += branch.recursive_depth_trace()
	return count


# Marks the encounter and it's branches as bypassed, recursively.
func bypass() -> void:
	bypassed = true
	for branch in branches:
		branch.bypass()
