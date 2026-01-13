extends PanelContainer
## Control panel for debug options so they can be easily toggled mid game.

@onready var god_mode_toggle := %GodModeToggle
@onready var accept_all_letters_toggle := %AcceptAllLettersToggle
@onready var accept_all_words_toggle := %AcceptAllWordsToggle
@onready var instawin_toggle := %InstawinToggle

@onready var log_level_dropdown := %LogLevelDropdown

func _ready():
	god_mode_toggle.button_pressed = DebugNode.god_mode
	accept_all_letters_toggle.button_pressed = DebugNode.accept_all_letters
	accept_all_words_toggle.button_pressed = DebugNode.accept_all_words
	instawin_toggle.button_pressed = DebugNode.instawin
	log_level_dropdown.selected = DebugNode.log_level
	log_level_dropdown.text = 'Log Level: ' + log_level_dropdown.text

	if DebugNode.god_mode:
		accept_all_letters_toggle.disabled = true
		accept_all_words_toggle.disabled = true
		instawin_toggle.disabled = true


func _on_god_mode_toggle_toggled(is_on : bool) -> void:
	DebugNode.god_mode = is_on
	if is_on:
		accept_all_letters_toggle.disabled = true
		accept_all_words_toggle.disabled = true
		instawin_toggle.disabled = true
	else:
		accept_all_letters_toggle.disabled = false
		accept_all_words_toggle.disabled = false
		instawin_toggle.disabled = false


func _on_accept_all_letters_toggle_toggled(is_on : bool) -> void:
	DebugNode.accept_all_letters = is_on


func _on_accept_all_words_toggle_toggled(is_on : bool) -> void:
	DebugNode.accept_all_words = is_on


func _on_instawin_toggle_toggled(is_on : bool) -> void:
	DebugNode.instawin = is_on


func _on_log_level_dropdown_item_selected(index : int) -> void:
	DebugNode.log_level = index
	log_level_dropdown.text = 'Log Level: ' + log_level_dropdown.text