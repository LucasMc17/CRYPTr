@abstract class_name Hook
extends Resource
## Custom resource representing a hook to be paired with at least one Function.
##
## Represents only the event that should activate the Hook (exact signal name form global Events file)

## The Hook's name.
@export var hook_name : String
## The maximum memory to be allocated to this Hook's Functions.
@export var memory_limit := 5
## The rarity of the Hook.
@export_enum("COMMON", "RARE", "EPIC") var rarity = 0
## The memory currently used by functions.
var memory_in_use : int:
	get():
		return functions.reduce(func(a,b): return a + b.cost, 0)
## The memory available for use.
var memory_available : int:
	get():
		return memory_limit - memory_in_use
## The signal which this Hook listens for.
var events_signal : String
## The Functions associated with the Hook.
var functions : Array[Function] = []
# NOTE: The below is not working because DebugNode is not ready at the time of initialization if we are using force hooks
## Debug print callable.
var to_dictionary : Callable = DebugNode.make_to_printable_method(self, ["memory_limit", "memory_in_use", "functions", "hook_name", "events_signal"]) if DebugNode else func(): return

func _init():
	if Events.has_signal(events_signal):
		Events[events_signal].connect(_on_triggered)


## Called whenever the designated signal (events_signal) is received to determine if the Functions should be triggered.
## Returns true if Functions should fire.
@abstract func filter(params : Events.ParamsObject) -> bool


## Add a Function to the list of Functions for this Hook.
func add_function(function : Function) -> void:
	if function.owning_hook != null:
		return
	if memory_available >= function.cost:
		function.owning_hook = self
		functions.append(function)
	else:
		DebugNode.print("WARNING: attempted to add Function of cost " + str(function.cost) + ", but only " + str(memory_available) + " memory remaining.")


## Move a function up or down in priority inside of this hook.
func shift_function(hook_index : int, up : bool) -> void:
	if up:
		if hook_index == 0:
			DebugNode.print("WARNING: Attempted to increase priority of Function whose index was already 0")
			return
		var shifted_func = functions.pop_at(hook_index)
		functions.insert(hook_index - 1, shifted_func)
	else:
		if hook_index == functions.size() - 1:
			DebugNode.print("WARNING: Attempted to decrease priority of Function whose index was already last in functions array")
			return
		var shifted_func = functions.pop_at(hook_index)
		functions.insert(hook_index + 1, shifted_func)


## Remove a Function to the list of Functions for this Hook.
func remove_function(function : Function) -> void:
	functions = functions.filter(func(hook_function): return hook_function != function)
	function.owning_hook = null


## Remove all Functions.
func clear_functions():
	for function in functions:
		function.owning_hook = null
	functions.clear()


## Signal listener function that runs when the Hook's designated signal is received.
func _on_triggered(params : Events.ParamsObject) -> void:
	if !filter(params):
		return
	DebugNode.p(hook_name + ' triggered!')
	for function in functions:
		function.run()
