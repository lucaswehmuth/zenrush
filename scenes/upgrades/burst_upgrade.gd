class_name BurstUpgrade
extends BasePlayerUpgrade

func _init() -> void:
	upgrade_name = "Burst Damage"
	description = "Add one extra projectile per shot"
	
func apply(player: Player) -> void:
	player.burst_count += 1
