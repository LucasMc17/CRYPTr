extends Node

var SCORE := 0
var TARGET_SCORE := 100

var ENCOUNTER_STACK : Array[CryptographRes]

func initialize_encounter(depth : int, security_level : int) -> void:
	ENCOUNTER_STACK = Player.STACK.duplicate()
	ENCOUNTER_STACK.shuffle()

	SCORE = 0
	TARGET_SCORE = (100 + (20 * security_level)) * depth