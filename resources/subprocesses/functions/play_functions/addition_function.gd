class_name AdditionFunction
extends Function
## Function which immediately adds an amount to the score of the currently evaluating word.

## The amount to be added to the score of the evaluated word.
@export var adder := 5

func _init():
	function_name = "add_to_score(5)"

func run() -> void:
	Events.hook_addition.emit(adder)