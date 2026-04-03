class_name ExplosiveUpgrade
extends BaseProjectileUpgrade

@export var radius: float = 80.0
@export var damage_multiplier: float = 0.25

func _init() -> void:
	upgrade_name = "Explosive"
	description = "Projectiles explode on impact"
	category = BaseUpgrade.Category.SPECIAL

func apply(projectile: BaseProjectile) -> void:
	projectile.explodes = true
	projectile.explosion_radius = radius
	projectile.explosion_damage_multiplier = damage_multiplier
