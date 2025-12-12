extends Switchable
## Pause menu showing the current state of a player's deck.

# @onready var letter_odds_holder = %LetterOddsHolder
@onready var letter_odds_panel = %LetterOddsPanel
@onready var vowel_odds_panel = %VowelOdds
@onready var stack_switcher = %StackSwitcher
@onready var current_stack_button = %CurrentStackButton
@onready var full_stack_button = %FullStackButton

func _ready():
	## TODO: Size is a bad way to track this. Need a boolean somewhere.
	if Player.current_stack.size():
		letter_odds_panel.update_odds(Player.current_stack)
		vowel_odds_panel.update_odds(Player.current_stack)
	else:
		stack_switcher.visible = false
		letter_odds_panel.update_odds(Player.stack)
		vowel_odds_panel.update_odds(Player.stack)

func _on_current_stack_button_pressed():
	letter_odds_panel.update_odds(Player.current_stack)
	vowel_odds_panel.update_odds(Player.current_stack)

func _on_full_stack_button_pressed():
	letter_odds_panel.update_odds(Player.stack)
	vowel_odds_panel.update_odds(Player.stack)