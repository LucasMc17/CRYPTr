@abstract class_name LetterHook
extends Hook
## Abstract class for Hooks triggered by a letter scoring.

func _init():
	events_signal = "letter_scored"
	super()