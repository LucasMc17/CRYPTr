class_name Word extends Label

func add_character(character : String) -> void:
	text += character

func backspace() -> void:
	text = text.substr(0, text.length() - 1)

func clear() -> void:
	text = ''