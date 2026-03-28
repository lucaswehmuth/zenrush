class_name HealthRegenUpgrade
extends BasePlayerUpgrade

@export var regen_per_second: float = 2.0

func _init() -> void:
	upgrade_name = "Health Regen"
	description = "Regenerates health every second"

func apply(player: Player) -> void:
	player.health_regen += regen_per_second
