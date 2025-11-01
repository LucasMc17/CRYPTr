class_name Hand extends HBoxContainer

var cryptograph_scene = preload('res://scenes/cryptograph.tscn')

var cryptographs : Array[Cryptograph]

var count : int:
	get():
		return cryptographs.size()
	set(val):
		push_warning("Cannot directly set hand size")

var letters : Array:
	get():
		var result : Array = cryptographs.map(func (crypt) -> String : return crypt.RESOURCE.letter.character)
		return result
	set(val):
		push_warning("Cannot directly set letters")
		pass

func add_to_hand(cryptographs_to_add : Array[CryptographRes]) -> void:
	for resource in cryptographs_to_add:
		var new_scene = cryptograph_scene.instantiate()
		new_scene.RESOURCE = resource
		cryptographs.append(new_scene)
		add_child(new_scene)

func discard_by_letters(word : String) -> void:
	var to_discard := []
	for i in range(cryptographs.size()):
		var cryptograph = cryptographs[i]
		var character = cryptograph.RESOURCE.letter.character
		if word.contains(character):
			to_discard.push_front(i)
			# discard_count += 1
			cryptograph.queue_free()
	for index in to_discard:
		cryptographs.remove_at(index)

func discard_all() -> void:
	for cryptograph in cryptographs:
		cryptograph.queue_free()
	cryptographs.clear()
