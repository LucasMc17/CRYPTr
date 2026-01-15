extends PanelContainer

@onready var _money_label := %MoneyLabel

func _ready():
	Events.money_changed.connect(_on_money_changed)
	Events.command_give_money.connect(_on_give_money_command_received)


func _on_money_changed(_params : Events.ParamsObject):
	if DebugNode.infinite_money:
		_money_label.text ="$INF"
	else:
		_money_label.text = "$" + str(Player.money)


func _on_give_money_command_received(params) -> void:
	if params.is_empty():
		DebugNode.error("ERROR: Please specify an amount of money, i.e. give_money 100")
		return
	if !params[0].is_valid_int():
		DebugNode.error("Error: The passed parameter '" + params[0] + "' is not an integer.")
		return
	Player.change_money(params[0].to_int())