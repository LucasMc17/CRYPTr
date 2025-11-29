class_name Word extends Label
## Scene representing the word input field during an encounter.

## Adds the given character to the inputted word.
func add_character(character : String) -> void:
	text += character


## Clears a character from the end of the inputted word.
func backspace() -> void:
	text = text.substr(0, text.length() - 1)


## Clears the word.
func clear() -> void:
	text = ''