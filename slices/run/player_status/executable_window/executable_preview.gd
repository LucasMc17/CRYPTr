extends Control

## The index of this Executable Preview within the list of Player executables.
@export var index := 0

## The hook which this Preview represents. On change, the text of the label should update, and the HookText should refresh.
var executable : Executable:
	set(val):
		if val:
			if name_label:
				name_label.text = val.executable_name
			if summary:
				summary.text = "# " + val.description
		else:
			name_label.text = "<No Executable Available>"
			summary.text = ""
		executable = val

@onready var index_label = %Index
@onready var name_label = %ExecutableName
@onready var summary_panel = %SummaryPanel
@onready var summary = %Summary

func _ready():
	Events.refresh_executables.connect(populate)
	index_label.text = str(index) + ":"
	populate()


func populate():
	if Player.executables.size() > index:
		executable = Player.executables[index]
	else:
		executable = null



func _on_h_box_container_mouse_entered():
	if executable:
		summary_panel.visible = true


func _on_h_box_container_mouse_exited():
	summary_panel.visible = false


func _on_run_button_pressed():
	if executable:
		executable.run()
