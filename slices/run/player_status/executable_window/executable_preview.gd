extends Control

## The index of this Executable Preview within the list of Player executables.
@export var index := 0

## The hook which this Preview represents. On change, the text of the label should update, and the HookText should refresh.
var executable : Executable:
	set(val):
		if val:
			if button_holder:
				button_holder.visible = true
			if name_label:
				name_label.text = val.executable_name
			if summary:
				summary.text = "# " + val.description
		else:
			if button_holder:
				button_holder.visible = false
			name_label.text = "<No Executable Available>"
			summary.text = ""
		executable = val

@onready var index_label = %Index
@onready var name_label = %ExecutableName
@onready var summary_panel = %SummaryPanel
@onready var summary = %Summary
@onready var button_holder = %ButtonHolder
@onready var run_button = %RunButton

func _ready():
	Events.refresh_executables.connect(populate)
	Events.refresh_executable_access.connect(change_applicability)
	index_label.text = str(index) + ":"
	populate()


## Update executable value based on Player's executable array.
func populate():
	if Player.executables.size() > index:
		executable = Player.executables[index]
	else:
		executable = null


## Enable the run button when appropriate.
func change_applicability():
	if executable:
		run_button.disabled = !executable.get_applicability()


func _on_h_box_container_mouse_entered():
	if executable:
		summary_panel.visible = true


func _on_h_box_container_mouse_exited():
	summary_panel.visible = false


func _on_run_button_pressed():
	if executable:
		executable.run()


func _on_discard_button_pressed():
	if executable:
		Player.remove_executable(executable)
