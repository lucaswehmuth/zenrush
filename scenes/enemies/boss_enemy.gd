class_name BossEnemy
extends BaseEnemy

@export var shard_drop_count: int = 40
@export var shard_drop_radius: float = 40.0

func die() -> void:
	if shard_scene:
		for i in shard_drop_count:
			var shard = shard_scene.instantiate()
			shard.value = shard_value
			var offset = Vector2.from_angle(randf() * TAU) * randf_range(0.0, shard_drop_radius)
			shard.global_position = global_position + offset
			if player and player.shard_magnet:
				shard._attract_on_ready = true
			get_tree().current_scene.add_child.call_deferred(shard)
	if player and player.vampirism > 0.0:
		player.current_health = min(player.max_health, player.current_health + player.vampirism)
		player.healthbar.health = player.current_health
	died.emit(self)
	queue_free.call_deferred()
