class_name DamageUpgrade
extends BasePlayerUpgrade

@export var damage_bonus: float = 5.0

func _init() -> void:
	upgrade_name = "Damage Up"
	description = "Increases base damage"
	
func apply(player: Player) -> void:
	player.base_damage += damage_bonus
