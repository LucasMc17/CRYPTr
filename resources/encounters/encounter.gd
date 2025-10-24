class_name EncounterRes extends Resource

# EXPORTS
@export_group("Encounter Info")
@export_enum("MATCH", "SHOP", "NEW_CGRAPH", "NEW_EXE", "REDISTRIBUTE") var type : String
@export var security_level := 0
@export var current_position := false

@export_group("Branches")
@export var parent : EncounterRes
# @export var boss_branch : BossEncounterResource
@export var branches : Array[EncounterRes]
