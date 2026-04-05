extends Control

signal upgrade_chosen(upgrade: BaseUpgrade)

@onready var button_1: Button = $PanelContainer/VBoxContainer/HBoxContainer/Button1
@onready var button_2: Button = $PanelContainer/VBoxContainer/HBoxContainer/Button2


func _ready() -> void:
	print_tree_pretty()
	hide()
	button_1.pressed.connect(_on_button_1_pressed)
	button_2.pressed.connect(_on_button_2_pressed)

var _current_offers: Array[BaseUpgrade] = []

func show_upgrades(offers: Array[BaseUpgrade]) -> void:
	_current_offers = offers
	button_1.text = offers[0].upgrade_name + "\n" + offers[0].description
	button_2.text = offers[1].upgrade_name + "\n" + offers[1].description
	show()

func _on_button_1_pressed() -> void:
	_choose(_current_offers[0])

func _on_button_2_pressed() -> void:
	_choose(_current_offers[1])

func _choose(upgrade: BaseUpgrade) -> void:
	upgrade_chosen.emit(upgrade)
	hide()
