## A shuffled instance of a Stack, for an encounter or other event requiring a full, shuffled copy of the player's deck
class_name DeckModule extends Node

var _ENCOUNTER_STACK : Array[CryptographRes]

var all : Array[CryptographRes]:
	get():
		return _ENCOUNTER_STACK
	set(val):
		push_warning("Cannot directly set cards in encounter stack")
		pass

var cryptograph_scene = preload('res://scenes/cryptograph.tscn')

func init_and_shuffle() -> void:
	_ENCOUNTER_STACK.clear()
	_ENCOUNTER_STACK.append_array(Player.STACK.duplicate())
	_ENCOUNTER_STACK.shuffle()

func draw(count := 6) -> Array[CryptographRes]:
	var cryptographs : Array[CryptographRes] = []
	while count > 0:
		cryptographs.append(_ENCOUNTER_STACK.pop_front())
		count -= 1
	return cryptographs

# func discard(letters : Array[LetterRes]) -> void:
# 	var i = 0
# 	for cryptograph : Cryptograph in HAND:
# 		if letters.has(cryptograph.letter):
# 			HAND.remove_at(i)
# 			cryptograph.queue_free()
# 		i += 1

# func discard_and_draw(letters : Array[LetterRes]) -> void:
# 	discard(letters)
# 	if HAND.size() < 6:
# 		draw(6 - HAND.size())

