extends PanelContainer

@onready var _money_label := %MoneyLabel

func _ready():
	Events.money_changed.connect(_on_money_changed)


func _on_money_changed(_params : Events.ParamsObject):
	_money_label.text = "$" + str(Player.money)