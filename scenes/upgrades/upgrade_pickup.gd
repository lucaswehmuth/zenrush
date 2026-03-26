class_name UpgradePickup
extends Area2D

@export var player_upgrade: BasePlayerUpgrade
@export var projectile_upgrade: BaseProjectileUpgrade

@onready var label: Label = $Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if player_upgrade:
		label.text = player_upgrade.upgrade_name
	elif projectile_upgrade:
		label.text = projectile_upgrade.upgrade_name

func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	if player_upgrade:
		player_upgrade.apply(body)
		body.player_upgrades.append(player_upgrade)
	if projectile_upgrade:
		body.projectile_upgrades.append(projectile_upgrade)
		projectile_upgrade.apply(body)
	queue_free()
