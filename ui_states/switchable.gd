class_name Switchable
extends Control
## Custom control scene designed to be swapped in and out by a `UISwitcher`. Initializes default parameters for the scene as well via the `setup` method.

## The switcher responsible for swapping this Switchable scene into position
var parent_switcher : UISwitcher

## Function to setup new Switchable instance with passed parameters. Something like a custom init function for Switchables.
## Structure of the init_obj param sshould match the properties of the Switchable. Any keys not found in the Switchable will have no effect.
## Setup function should be used primarily for initializing params, but can be extended to other purposes.
func setup(init_obj := {}) -> void:
	for key in init_obj:
		var value = init_obj[key]
		if key in self:
			self[key] = value