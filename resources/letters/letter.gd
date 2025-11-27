class_name LetterRes
extends Resource 
## Custom resource representing a letter and associated points.

@export_group("Letter Info")
## The character, A, B, C, etc.
@export var character : String
## The point value of the letter, depending on the difficulty of using the letter in a valid word.
@export var points : int
