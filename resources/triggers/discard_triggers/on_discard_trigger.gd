class_name OnDiscardTrigger
extends Trigger
## Discard trigger activated whenever any letter is discarded.

func _init():
	events_signal = "cryptograph_discarded"
	super()


func filter(_params : Events.ParamsObject) -> bool:
	return true