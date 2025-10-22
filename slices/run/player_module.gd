extends Node

var STACK : Array[CryptographRes] = []

func draw(count: int) -> void:
	print('hi')

func initialize_stack(starter_stack: StarterDeckRes) -> Array[CryptographRes]:
	var result = []
	for cryptograph in starter_stack.cryptographs:
		result.append(cryptograph.duplicate())
	return result