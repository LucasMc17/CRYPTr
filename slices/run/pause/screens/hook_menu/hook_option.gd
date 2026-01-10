extends Button

## Signal indicating button was pressed and hook has been selected:
signal hook_selected(hook : Hook)

## The index of this Hook Preview within the list of Player hooks.
@export var index := 0

## The Hook the player selects by clicking this button.
var _hook : Hook

@onready var name_label := %NameLabel
@onready var memory_label := %MemoryLabel

func _ready():
	Events.refresh_hooks.connect(update_hook)
	if Player.hooks.size() > index:
		_hook = Player.hooks[index]
	else:
		_hook = null
	update_hook()


func _pressed():
	hook_selected.emit(_hook)


## Update the text of the button as details of the Hook resource change.
func update_hook():
	if _hook:
		name_label.text = _hook.hook_name
		memory_label.text = str(_hook.memory_in_use) + ' / ' + str(_hook.memory_limit)
