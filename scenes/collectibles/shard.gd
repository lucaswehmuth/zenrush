class_name Shard
extends Area2D

var value: int = 1
@export var attraction_speed: float = 400.0

var _player: Node2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_player = get_tree().get_first_node_in_group("player")
	set_physics_process(false)

func attract() -> void:
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(_player):
		return
	var direction = (_player.global_position - global_position).normalized()
	global_position += direction * attraction_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.shards += value
		queue_free()
