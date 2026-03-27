extends Node2D

@onready var stats_label: Label = $CanvasLayer/Control/StatsLabel
@onready var reset_button: Button = $CanvasLayer/Control/HBoxContainer/ResetButton
@onready var back_button: Button = $CanvasLayer/Control/HBoxContainer/BackButton
@onready var upgrades_label: Label = $CanvasLayer/Control/UpgradesLabel

@onready var player: Player = $Player

func _ready() -> void:
	reset_button.pressed.connect(_on_reset)
	back_button.pressed.connect(_on_back)
	for pickup in get_tree().get_nodes_in_group("pickup"):
		pickup.picked_up.connect(_on_pickup)
	_update_stats()

func _on_pickup(upgrade_name: String) -> void:
	upgrades_label.text += "%s\n" % upgrade_name
	_update_stats()

func _on_reset() -> void:
	get_tree().reload_current_scene()
	
func _on_back() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _update_stats() -> void:
	stats_label.text = "HP: %s/%s\nSpeed: %s\nCooldown: %s\nRange: %s\nBurst: %s" % [
		player.current_health,
		player.max_health,
		player.move_speed,
		snappedf(player.attack_cooldown, 0.01),
		player.range_percent,
		player.burst_count
	]


func _on_reset_button_button_up() -> void:
	get_tree().reload_current_scene()


func _on_back_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
