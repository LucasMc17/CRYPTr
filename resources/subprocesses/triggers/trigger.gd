@abstract class_name Trigger
extends Resource
## Custom resource representing a trigger to be paired with at least one Effect to create a SubRoutine.
##
## Represents only the event that should activate the trigger (exact signal name form global Events file)
## and the cost of activating.

## Emitted when the trigger is activated, received by the owning subprocess to in turn activate its effects.
signal triggered()

## The Trigger's name.
var trigger_name : String
## The signal which this Trigger listens for.
var events_signal : String
## The memory cost of installing this Trigger.
var cost := 1

func _init():
	if Events.has_signal(events_signal):
		Events[events_signal].connect(_on_triggered)


## Called whenever the designated signal (events_signal) is received to determine if the effects should be triggered.
## Returns true if effects should fire.
@abstract func filter(params : Events.ParamsObject) -> bool


## Signal listener function that runs when the triggers designated signal is received.
func _on_triggered(params : Events.ParamsObject) -> void:
	if !filter(params):
		return
	DebugNode.p(trigger_name + ' triggered!')
	triggered.emit()
