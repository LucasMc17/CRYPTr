@abstract class_name WordHook
extends Hook
## Abstract class for Hooks triggered by a word scoring.

func _init():
	events_signal = "word_scored"
	super()