class_name PierceUpgrade
extends BaseProjectileUpgrade

@export var pierce_bonus: int = 1

func _init() -> void:
	upgrade_name = "Pierce"
	description = "Projectiles pierce through enemies"
	category = BaseUpgrade.Category.SPECIAL

func apply(projectile: BaseProjectile) -> void:
	projectile.pierce_count += pierce_bonus
