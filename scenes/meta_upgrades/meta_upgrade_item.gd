extends PanelContainer

signal buy_pressed(upgrade_id: String)

@onready var name_label = $MarginContainer/Row/Top/Name
@onready var level_label = $MarginContainer/Row/Top/Level
@onready var cost_label = $MarginContainer/Row/Bottom/Cost
@onready var buy_button = $MarginContainer/Row/Bottom/BuyButton

var upgrade_id: String

func setup(id: String, p_name: String, level: int, cost: int, can_afford: bool, is_maxed: bool, is_locked: bool, req_text: String = "") -> void:
	upgrade_id = id
	name_label.text = p_name
	if is_locked:
		level_label.text = req_text
		cost_label.text = "LOCKED"
		buy_button.disabled = true
	elif is_maxed:
		level_label.text = "Level %d" % level
		cost_label.text = "MAX"
		buy_button.disabled = true
	else:
		level_label.text = "Level %d" % level
		cost_label.text = str(cost)
		buy_button.disabled = not can_afford

func _ready() -> void:
	buy_button.pressed.connect(_on_buy_pressed)

func _on_buy_pressed() -> void:
	buy_pressed.emit(upgrade_id)
