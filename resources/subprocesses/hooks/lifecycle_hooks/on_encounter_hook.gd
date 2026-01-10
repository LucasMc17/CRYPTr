class_name OnMatchHook
extends Hook
## Lifecycle Hook activated when a match is entered.

func _init():
	events_signal = "match_started"
	super()


func filter(_params) -> bool:
	return true
