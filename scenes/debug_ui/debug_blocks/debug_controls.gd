extends PanelContainer
## Control panel for debug options so they can be easily toggled mid game.

@onready var god_mode_toggle := %GodModeToggle
@onready var accept_all_letters_toggle := %AcceptAllLettersToggle
@onready var accept_all_words_toggle := %AcceptAllWordsToggle
@onready var instawin_toggle := %InstawinToggle

func _ready():
	god_mode_toggle.button_pressed = DebugNode.GOD_MODE
	accept_all_letters_toggle.button_pressed = DebugNode.ACCEPT_ALL_LETTERS
	accept_all_words_toggle.button_pressed = DebugNode.ACCEPT_ALL_WORDS
	instawin_toggle.button_pressed = DebugNode.INSTAWIN

	if DebugNode.GOD_MODE:
		accept_all_letters_toggle.disabled = true
		accept_all_words_toggle.disabled = true
		instawin_toggle.disabled = true


func _on_god_mode_toggle_toggled(is_on : bool) -> void:
	DebugNode.GOD_MODE = is_on
	if is_on:
		accept_all_letters_toggle.disabled = true
		accept_all_words_toggle.disabled = true
		instawin_toggle.disabled = true
	else:
		accept_all_letters_toggle.disabled = false
		accept_all_words_toggle.disabled = false
		instawin_toggle.disabled = false


func _on_accept_all_letters_toggle_toggled(is_on : bool) -> void:
	DebugNode.ACCEPT_ALL_LETTERS = is_on


func _on_accept_all_words_toggle_toggled(is_on : bool) -> void:
	DebugNode.ACCEPT_ALL_WORDS = is_on


func _on_instawin_toggle_toggled(is_on : bool) -> void:
	DebugNode.INSTAWIN = is_on