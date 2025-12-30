@abstract class_name Function
extends Resource
## An effect, triggerable by a Hook, which describes a specific, benficial event for the player.
## 
## Has a memory cost which must be equal to or lesser than the Hook's remaining memory in order be installed.

## The Function's name, formatted as a function call. Should be descriptive of the Functions utility.
var function_name : String
## The memory cost of installing this function
var cost := 1
## The Hook on which this Function is currently installed. Will return `null` if this Function is not currently in use anywhere.
var owning_hook : Hook

## The func which triggers the Function's advantageous effect, typically by emitting a global event.
@abstract func run() -> void