class_name MaxHealthUpgrade
extends BasePlayerUpgrade

@export var health_bonus: float = 50.0

func _init() -> void:
	upgrade_name = "Max Health Up"
	description = "Increases maximum health"

func apply(player: Player) -> void:
	player.max_health += health_bonus
	player.current_health += health_bonus
	player.healthbar.init(player.max_health)
