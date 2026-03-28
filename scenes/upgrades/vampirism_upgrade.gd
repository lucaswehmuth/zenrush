class_name VampirismUpgrade
extends BasePlayerUpgrade

@export var heal_per_kill: float = 5.0

func _init() -> void:
	upgrade_name = "Vampirism"
	description = "Heals on every enemy kill"

func apply(player: Player) -> void:
	player.vampirism += heal_per_kill
