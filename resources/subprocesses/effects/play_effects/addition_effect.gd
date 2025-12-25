class_name AdditionEffect
extends Effect
## 
##
## 

var adder : int

func _init(effect_adder : int):
	adder = effect_adder

func run() -> void:
	Events.subprocess_addition.emit(adder)