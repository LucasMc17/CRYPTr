class_name Hand
extends HBoxContainer
## Scene representing the player's hand during an encounter.

## Preloaded cryptograph scene for instantiating new cryptographs.
var _cryptograph_scene = preload('res://scenes/cryptograph.tscn')
## All Cryptograph scenes in hand.
var cryptographs : Array[Cryptograph]

## Read only property for fetching the current number of cryptographs in the hand.
var count : int:
	get():
		return cryptographs.size()
	set(val):
		push_warning("Cannot directly set hand size")
## Read only property for fetching the letters in the player's hand as an array of single character strings.
var letters : Array:
	get():
		# NOTE: this is a good example of a typed array I can't seem to fully indicate the type of without breaking the func. Exclusively because of the map method which returns an untyped array
		var result : Array = cryptographs.map(func (crypt) -> String : return crypt.resource.letter.character)
		return result
	set(val):
		push_warning("Cannot directly set letters")
		pass

## Creates scenes for the array of cryptograph resources passed into the function, then appends them to the hand.
func add_to_hand(cryptographs_to_add : Array[CryptographRes]) -> void:
	for resource in cryptographs_to_add:
		var new_scene = _cryptograph_scene.instantiate()
		new_scene.resource = resource
		cryptographs.append(new_scene)
		add_child(new_scene)


## Discards all the cryptographs in hand which match the word passed to the function.
func discard_by_letters(word : String) -> void:
	var to_discard := []
	for i in range(cryptographs.size()):
		var cryptograph = cryptographs[i]
		var character = cryptograph.resource.letter.character
		if word.contains(character):
			to_discard.push_front(i)
			cryptograph.queue_free()
	for index in to_discard:
		cryptographs.remove_at(index)


## Discards a single cryptograph from the hand.
func discard(cryptograph : Cryptograph) -> void:
	cryptograph.queue_free()
	cryptographs = cryptographs.filter(func (crypt): return crypt != cryptograph)


## Discards all cryptographs from the hand and resets to an empty array.
func discard_all() -> void:
	for cryptograph in cryptographs:
		cryptograph.queue_free()
	cryptographs.clear()
