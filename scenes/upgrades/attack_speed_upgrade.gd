class_name AttackSpeedUpgrade
extends BasePlayerUpgrade

@export var cooldown_reduction: float = 0.05

func _init() -> void:
	upgrade_name = "Attack Speed"
	description = "Increases amount of shots per second"
	
func apply(player: Player) -> void:
	player.attack_cooldown = max(0.1, player.attack_cooldown - cooldown_reduction)
	print("Attack cooldown after upgrade: ", player.attack_cooldown)
