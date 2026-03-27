extends Node2D

@onready var stats_label: Label = $CanvasLayer/Control/StatsLabel
@onready var reset_button: Button = $CanvasLayer/Control/ResetButton
@onready var upgrades_label: Label = $CanvasLayer/Control/UpgradesLabel

@onready var player: Player = $Player

func _ready() -> void:
	reset_button.pressed.connect(_on_reset)
	for pickup in get_tree().get_nodes_in_group("pickups"):
		pickup.picked_up.connect(_on_pickup)
	_update_stats()

func _on_pickup(upgrade_name: String) -> void:
	upgrades_label.text += "- %s\n" % upgrade_name
	_update_stats()

func _on_reset() -> void:
	get_tree().reload_current_scene()

func _update_stats() -> void:
	stats_label.text = "HP: %s/%s\nSpeed: %s\nCooldown: %s" % [
		player.current_health,
		player.max_health,
		player.move_speed,
		snappedf(player.attack_cooldown, 0.01)
	]
