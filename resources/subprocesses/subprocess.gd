class_name Subprocess
extends Resource
## 
## 
## 

const MEMORY_LIMIT := 6

var trigger : Trigger:
	set = _set_trigger

var effects : Array[Effect]
var memory_used : int:
	get():
		var mem = 0
		if trigger:
			mem += trigger.cost
		for effect in effects:
			mem += effect.cost
		return mem
var available_memory : int:
	get():
		return MEMORY_LIMIT - memory_used
var to_dictionary : Callable = DebugNode.make_to_printable_method(self, ["trigger", "effects", "memory_used", "available_memory"])


func _set_trigger(new_trigger : Trigger) -> void:
	var real_memory = available_memory + trigger.cost if trigger else available_memory
	if new_trigger.cost > real_memory:
		DebugNode.print("WARNING: attempted to add trigger of cost " + str(new_trigger.cost) + ", but only " + str(real_memory) + " memory remaining (excluding current trigger, if present).")
		return
	if trigger:
		trigger.triggered.disconnect(_activate)
	trigger = new_trigger
	trigger.triggered.connect(_activate)


func _activate():
	for effect in effects:
		effect.run()


func add_effect(effect : Effect):
	if MEMORY_LIMIT - memory_used >= effect.cost:
		effects.append(effect)
	else:
		DebugNode.print("WARNING: attempted to add effect of cost " + str(effect.cost) + ", but only " + str(MEMORY_LIMIT - memory_used) + " memory remaining.")