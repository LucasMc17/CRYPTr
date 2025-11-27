class_name CryptographRes
extends Resource
## Custom resource representing a cryptograph in the player's posession.

@export_group("Cryptograph Info")
## The letter of the cryptograph.
@export var letter : LetterRes

@export_group("Enhancements")
## The level of the cryptograph, which can be upgraded across a run.
@export var level := 1
