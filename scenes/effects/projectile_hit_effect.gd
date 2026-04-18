extends CPUParticles2D

func _ready() -> void:
	color = modulate
	emitting = true
	await get_tree().create_timer(lifetime).timeout
	queue_free()
