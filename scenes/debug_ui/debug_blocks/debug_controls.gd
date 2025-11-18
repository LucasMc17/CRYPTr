extends PanelContainer

@onready var GOD_MODE_TOGGLE := %GodModeToggle
@onready var ACCEPT_ALL_LETTERS_TOGGLE := %AcceptAllLettersToggle
@onready var ACCEPT_ALL_WORDS_TOGGLE := %AcceptAllWordsToggle
@onready var INSTAWIN_TOGGLE := %InstawinToggle

func _ready():
	GOD_MODE_TOGGLE.button_pressed = DebugNode.GOD_MODE
	ACCEPT_ALL_LETTERS_TOGGLE.button_pressed = DebugNode.ACCEPT_ALL_LETTERS
	ACCEPT_ALL_WORDS_TOGGLE.button_pressed = DebugNode.ACCEPT_ALL_WORDS
	INSTAWIN_TOGGLE.button_pressed = DebugNode.INSTAWIN

	if DebugNode.GOD_MODE:
		ACCEPT_ALL_LETTERS_TOGGLE.disabled = true
		ACCEPT_ALL_WORDS_TOGGLE.disabled = true
		INSTAWIN_TOGGLE.disabled = true

func _on_god_mode_toggle_toggled(is_on : bool) -> void:
	DebugNode.print('God Mode On')
	DebugNode.GOD_MODE = is_on
	if is_on:
		ACCEPT_ALL_LETTERS_TOGGLE.disabled = true
		ACCEPT_ALL_WORDS_TOGGLE.disabled = true
		INSTAWIN_TOGGLE.disabled = true
	else:
		ACCEPT_ALL_LETTERS_TOGGLE.disabled = false
		ACCEPT_ALL_WORDS_TOGGLE.disabled = false
		INSTAWIN_TOGGLE.disabled = false

func _on_accept_all_letters_toggle_toggled(is_on : bool) -> void:
	DebugNode.ACCEPT_ALL_LETTERS = is_on


func _on_accept_all_words_toggle_toggled(is_on : bool) -> void:
	DebugNode.ACCEPT_ALL_WORDS = is_on

func _on_instawin_toggle_toggled(is_on : bool) -> void:
	DebugNode.INSTAWIN = is_on