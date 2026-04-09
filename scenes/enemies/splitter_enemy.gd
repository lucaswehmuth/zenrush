class_name SplitterEnemy
extends BaseEnemy

@export var split_count: int = 2
@export var split_into: int = 2
@export var scale_per_tier: float = 0.8
@export var drop_shards_on_split: bool = false

func die() -> void:
	if split_count > 0:
		_spawn_children()
		if not drop_shards_on_split:
			shard_scene = null
		super()
	else:
		super()

func _spawn_children() -> void:
	for i in split_into:
		var child: SplitterEnemy = duplicate()
		child.split_count = split_count - 1
		child.max_health = max_health * 0.5
		child.damage = damage * 0.75
		child.scale = scale * scale_per_tier
		var offset := Vector2.from_angle(TAU / split_into * i) * 20.0
		child.global_position = global_position + offset
		get_tree().current_scene.add_child.call_deferred(child)
