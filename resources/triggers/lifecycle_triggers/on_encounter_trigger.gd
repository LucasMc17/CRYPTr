class_name OnMatchTrigger
extends Trigger
## Lifecycle trigger activated when a match is entered.

func _init():
	events_signal = "match_started"
	super()


func filter(_params) -> bool:
	return true
