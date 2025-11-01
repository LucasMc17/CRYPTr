extends Node

func check_overrides(value):
	if GOD_MODE:
		return true
	else:
		return value

@export_category("Master Override")
@export var GOD_MODE := false

@export_category("Overrides")
@export var ACCEPT_ALL_LETTERS := false:
	get():
		return check_overrides(ACCEPT_ALL_LETTERS)
@export var ACCEPT_ALL_WORDS := false:
	get():
		return check_overrides(ACCEPT_ALL_WORDS)
@export var INSTAWIN := false:
	get():
		return check_overrides(INSTAWIN)