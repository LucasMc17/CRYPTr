class_name Switchable
extends Control
## Custom control scene designed to be swapped in and out by a `UISwitcher`. Initializes default parameters for the scene as well via the `setup` method.

## Dictionary representing parameters to setup Switchable with.
var params := {}

## Function to setup new Switchable instance with passed parameters. Something like a custom init function for Switchables.
## Structure of the init_obj param should match the params object. Any keys not found in the params object will have no effect.
## Setup function should be used primarily for initializing params, but can be extended to other purposes.
func setup(init_obj := {}) -> void:
	for key in init_obj:
		var value = init_obj[key]
		if params.has(key):
			params[key] = value