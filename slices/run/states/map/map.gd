@tool
extends Switchable

@export_category("DEBUG")
@export var RESET_BUTTON := true:
	set(val):
		print('DEBUG BUILD')
		ROOT_NODE.clear_children()
		ROOT_NODE.build()

@export var ENCOUNTER_MAP : EncounterRes
@export var CURRENT_ENCOUNTER : EncounterRes

@onready var ROOT_NODE = %RootNode

func _ready():
	ENCOUNTER_MAP = EncounterRes.new("MATCH", 3, null, 0, 3)
	CURRENT_ENCOUNTER = ENCOUNTER_MAP
	ROOT_NODE.ENCOUNTER = CURRENT_ENCOUNTER
	ROOT_NODE.build()
	print(ENCOUNTER_MAP.to_object())