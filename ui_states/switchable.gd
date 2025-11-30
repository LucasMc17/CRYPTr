class_name Switchable
extends Control
## Custom control scene designed to be swapped in and out by a `UISwitcher`. Initializes default parameters for the scene as well via the `setup` method.

## Dictionary representing default parameters to create Switchable with. Will be improved. See Map Switchable for a good example.
var default_params = {}

## Function to setup new Switchable instance with passed parameters. Something like a custom init function for Switchables.
func setup(_init_obj := {}) -> void:
	pass