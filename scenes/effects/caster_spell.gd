class_name CastSpell
extends Area2D

var damage: float = 0.0
var spell_duration: float = 0.4

func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	for area in get_overlapping_areas():
		if area is not Hurtbox:
			continue
		if area.get_parent().is_in_group("player"):
			area.get_parent().take_damage(damage)
	await get_tree().create_timer(spell_duration).timeout
	queue_free()
