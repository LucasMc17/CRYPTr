extends Node

var STACK : Array[CryptographRes] = []


func initialize_stack(starter_stack: StarterDeckRes) -> void:
	var result : Array[CryptographRes] = []
	for cryptograph in starter_stack.cryptographs:
		result.append(cryptograph.duplicate())
	STACK = result