extends Switchable
## Pause menu showing the current state of a player's deck.

@onready var letter_odds_panel = %LetterOddsPanel
@onready var vowel_odds_panel = %VowelOdds
@onready var cryptograph_grid = %CryptographGrid

@onready var stack_switcher = %StackSwitcher
@onready var current_stack_button = %CurrentStackButton
@onready var full_stack_button = %FullStackButton

## Runs initialize functions on the letter odds panel, the vowel offs panel, and the crypograph grid
func _build_menu_from_stack(stack : Array[CryptographRes]) -> void:
	letter_odds_panel.update_odds(stack)
	vowel_odds_panel.update_odds(stack)
	cryptograph_grid.initialize(stack)


func _ready():
	if Player.current_stack != Player.stack:
		_build_menu_from_stack(Player.current_stack)
	else:
		stack_switcher.visible = false
		_build_menu_from_stack(Player.stack)

func _on_current_stack_button_pressed():
		_build_menu_from_stack(Player.current_stack)

func _on_full_stack_button_pressed():
		_build_menu_from_stack(Player.stack)