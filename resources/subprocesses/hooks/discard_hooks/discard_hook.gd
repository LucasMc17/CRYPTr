@abstract class_name DiscardHook
extends Hook
## Abstract class for Hooks triggered by the act of discarding.

func _init():
	events_signal = "cryptograph_discarded"
	super()