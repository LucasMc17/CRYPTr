class_name DeckModule extends Node
## Logic module simulating a shuffled instance of a Stack, for an encounter or other event requiring a full, shuffled copy of the player's stack.
##
## Contains logic for drawing from the stack as well as shuffling.

## The player's stack as an array of Cryptograph Resources. This is initialized when the module is created, then is not meant to be accessed. Access `all` instead.
var _encounter_stack : Array[CryptographRes]
## The full list of cryptographs. Read only property so that all mutative logic is handled by the logic module itself, rather that from outside of it.
var all : Array[CryptographRes]:
	get():
		return _encounter_stack
	set(val):
		push_warning("Cannot directly set cards in encounter stack")
		pass

func _init(should_shuffle := false):
	_encounter_stack.clear()
	_encounter_stack.append_array(Player.stack.duplicate())
	Player.current_stack = _encounter_stack
	if should_shuffle:
		_encounter_stack.shuffle()


## Draws the inputted number of cryptographs from the stack, if it still contains enough cryptographs to draw. Mutates the stack.
func draw(count := Player.HAND_SIZE) -> Array[CryptographRes]:
	var cryptographs : Array[CryptographRes] = []
	while count > 0 && !_encounter_stack.is_empty():
		cryptographs.append(_encounter_stack.pop_front())
		count -= 1
	return cryptographs
