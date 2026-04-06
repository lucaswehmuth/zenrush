class_name ProjectileExplosion
extends Area2D

var damage: float = 0.0

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	cpu_particles_2d.emitting = true
	for area in get_overlapping_areas():
		if area is not Hurtbox:
			continue
		var enemy = area.get_parent()
		if enemy.is_in_group("enemy"):
			enemy.take_damage(damage)
	await get_tree().create_timer(0.5).timeout
	queue_free()
