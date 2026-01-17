class_name BonusHand
extends Hand
## Functions like Hand, except is specifically for non-discardable Cryptographs added through non-standard means, like pluralize.exe.


# TODO: This is ugly as hell. hand and bonus hand should both inherit from a common ancestor.

var s_cryptogtaph = preload("res://resources/cryptographs/s_cryptograph.tres")

func _ready():
	Events.pluralize_executed.connect(_on_pluralize_used)


func discard_by_letters(_word : String) -> void:
	return


func discard(_cryptograph : Cryptograph) -> void:
	return


func discard_all() -> void:
	return


func _on_cryptograph_right_clicked(_cryptograph : Cryptograph):
	return


func _on_pluralize_used():
	add_to_hand([s_cryptogtaph])